#version 330 core

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

in vec2 texcoord;

vec4 default_post_processing(vec4 c);

/* ----------------------------------------------------------
   brightness (default = 1.0)
   ----------------------------------------------------------
   pre_gain  → applied BEFORE palette quantization
               affects how colors are chosen
   post_gain → applied AFTER everything
               final brightness (clamped to avoid clipping)
---------------------------------------------------------- */
const float pre_gain  = 1.0;
const float post_gain  = 1.0;

/* ----------------------------------------------------------
   pywal color opacity (default = 1.0)
   ----------------------------------------------------------
   control the strength of the pywal colors
   replacing the original image

   0.0 → original image
   0.5 → blended / tinted
   1.0 → fully quantized palette
   >1  → oversaturated stylized look
---------------------------------------------------------- */
const float color_opacity = 1.0;

/* ----------------------------------------------------------
   dither pattern opacity (default = 0.5)
   ----------------------------------------------------------
   control how visible the dithering pattern is

   0.0 → smooth gradient (no pattern)
   1.0 → full dithering (pixelated look)
---------------------------------------------------------- */
const float dither_opacity = 0.5;

/* ----------------------------------------------------------
   contrast boost pre-dithering (default = 0.0)
   ----------------------------------------------------------
   push colors toward their nearest palette color
   BEFORE dithering or color quantization happens
---------------------------------------------------------- */
const float contrast_boost = 0.0;

/* ----------------------------------------------------------
   gamma correction (default = 1.0 for dark / 2.2 for light)
   ----------------------------------------------------------
   works after pre_gain brightness to adjust color selection

   1.0 → neutral dark
   2.2 → gamma boosted
---------------------------------------------------------- */
const float gamma = 1.0;

vec3 gamma_correct(vec3 color, float g) {
   return pow(color, vec3(1.0 / g));
}

/* ----------------------------------------------------------
   color distance
   ----------------------------------------------------------
   compute how close a color is to a pywal color entry

   lower value = better match
---------------------------------------------------------- */
float color_distance(vec3 c, vec3 p) {
   return dot(p, p) - 2.0 * dot(c, p);
}

/* ----------------------------------------------------------
   random noise
   ----------------------------------------------------------
   a built-in random function does not exist for GLSL
   so... guess we need to fake one ¯\_(ツ)_/¯

   these functions generate pseudo-random values based on
   fragment coordinates... creating dither noise that looks
   random, but does not flicker every frame
---------------------------------------------------------- */
float random(float seedChange) {
    /*   create a seed based on pixel position   */
    vec2 seed = gl_FragCoord.xy + sin(seedChange);
    /*   scramble the seed using trig + division   */
    float scrambled = sin(mod(seed.x / cos(seed.y), 5.0) * 10000.0);
    /*   dot product mixes values into a single float   */
    float mixed = dot(vec2(scrambled), vec2(1.1, 12.2));
    /*   fract keeps only the decimal part → 0.0 to 1.0   */
    return fract(mixed);
}

/* ----------------------------------------------------------
   main shader
---------------------------------------------------------- */
vec4 window_shader() {

    /* ------------------------------------------------------
       sample input texture
       ------------------------------------------------------
       use texture size to scale and to get proper
       sampling coordinates (texcoord is normalized 0–1)
    ------------------------------------------------------ */
    ivec2 texsize = textureSize(tex, 0);
    vec4 c = texture(tex, texcoord / vec2(texsize));
    vec4 out_color = c;

    /* ------------------------------------------------------
       pre-processing (brightness + gamma)
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * pre_gain, 0.0, 1.0);
    out_color.rgb = gamma_correct(out_color.rgb, gamma);

    /* ------------------------------------------------------
       contrast push
    ------------------------------------------------------ */
	float l = dot(out_color.rgb, vec3(0.299,0.587,0.114));
	out_color.rgb += (out_color.rgb - l) * contrast_boost;

    /* ------------------------------------------------------
       pywal-colors
    ------------------------------------------------------ */
    vec3 colors[16] = vec3[16](
        vec3({color0.red},{color0.green},{color0.blue}),
        vec3({color1.red},{color1.green},{color1.blue}),
        vec3({color2.red},{color2.green},{color2.blue}),
        vec3({color3.red},{color3.green},{color3.blue}),
        vec3({color4.red},{color4.green},{color4.blue}),
        vec3({color5.red},{color5.green},{color5.blue}),
        vec3({color6.red},{color6.green},{color6.blue}),
        vec3({color7.red},{color7.green},{color7.blue}),
        vec3({color8.red},{color8.green},{color8.blue}),
        vec3({color9.red},{color9.green},{color9.blue}),
        vec3({color10.red},{color10.green},{color10.blue}),
        vec3({color11.red},{color11.green},{color11.blue}),
        vec3({color12.red},{color12.green},{color12.blue}),
        vec3({color13.red},{color13.green},{color13.blue}),
        vec3({color14.red},{color14.green},{color14.blue}),
        vec3({color15.red},{color15.green},{color15.blue})
    );

    /* ------------------------------------------------------
       find two closest colors in palette
       ------------------------------------------------------
       for each pixel, search the pywal color palette for...
       best_index   → closest color match
       second_index → second closest match

       we use the two closest pywal colors to dither
       dithering works by alternating between the available
       colors to simulate colors beyond the pywal colors
    ------------------------------------------------------ */
    float best_distance = 1e20;
    float second_distance = 1e20;
    int best_index = 0;
    int second_index = 0;

    for (int i = 0; i < 16; i++) {
        /*   compute distance from current pixel to palette color   */
        float dist = color_distance(c.rgb, colors[i]);
        if (dist < best_distance) {
            /*   shift current best to second best   */
            second_distance = best_distance;
            second_index = best_index;
            /*   update best stuff   */
            best_distance = dist;
            best_index = i;
        }
        else if (dist < second_distance) {
            /* update second best only */
            second_distance = dist;
            second_index = i;
        }
    }

    /* ------------------------------------------------------
       dither pre-processing
       ------------------------------------------------------
       ratio determines how close the current pixel color is
       to the two nearest palette colors

       ratio also determines the color used for dithering

       ratio ≈ 0.0 → matches best_index
       ratio ≈ 1.0 → matches second_index
    ------------------------------------------------------ */
    float ratio = best_distance / (best_distance + second_distance + 1e-6);

    /* ------------------------------------------------------
       perceptual (luminance-based) color weighting
       ------------------------------------------------------
       human vision is more sensitive to green, less to blue

       this shifts the ratio to use perceived brightness
       differences instead of raw RGB distance, helping
       gradients look more natural
    -------------------------------------------------------*/
    vec3 mid = 0.5 * (colors[best_index] + colors[second_index]);

    /*   dot() approximates luminance   */
    ratio += dot(c.rgb - mid, vec3(0.299,0.587,0.114)) * 0.25;

    /*   keep ratio in valid range   */
    ratio = clamp(ratio, 0.0, 1.0);

    /* ------------------------------------------------------
       reduce dithering in solid color regions
       ------------------------------------------------------
       we do not want dither noise in places where it
       does not benefit from the dithering

       palette_proximity:
       - near 0 → far from palette → allow dithering
       - near 1 → very close → suppress dithering
    ------------------------------------------------------ */
    float palette_proximity = smoothstep(0.0, 0.02, best_distance);

    /*   bias toward "unity" ratio (0.5) when very close   */
    ratio = mix(0.5, ratio, palette_proximity);

    /*   smooth transitions to avoid harsh artifacts   */
    ratio = smoothstep(0.0, 1.0, ratio);

    /* ------------------------------------------------------
       stochastic (random) dither
       ------------------------------------------------------
       instead of a fixed pattern, use random noise to
       decide which color to pick per pixel, creating
       a grainy texture
    ------------------------------------------------------ */
    float randomness = random(1.0) * ratio;

    /* ------------------------------------------------------
       ratio-biased noise / threshold warping
       ------------------------------------------------------
       tldr: higher numbers → less dithering

       technically, it modifies the randomness so it better
       matches the distribution from the ratio

       practically, it changes how the dither noise gets
       stronger or weaker depending on the ratio, sort of

       this line does a lot of heavy lifting
       this line has MUCH potential
       this line has values that are totally arbitrary
       "3.33 + 0.33" for a noisy, but tasteful alternative
       "5.00 + 0.45" for a tamer, less noisy version
    ------------------------------------------------------ */
    randomness = randomness * 5 + 0.45;

    /* ------------------------------------------------------
       final color selection
       ------------------------------------------------------
       compare random value to ratio to decide which
       palette color a pixel becomes
    ------------------------------------------------------ */
    if (randomness > ratio)
        c.rgb = colors[best_index];
    else
        c.rgb = colors[second_index];

    /* ------------------------------------------------------
       final color blend
       ------------------------------------------------------
       mix the dithered result with a smooth gradient
       between the two palette colors, reducing harsh
       grain and flickering edges
    ------------------------------------------------------ */
    c.rgb = mix(mix(colors[best_index], colors[second_index], ratio), c.rgb, dither_opacity);

    /* ----------------------------------------------------------
       output brightness (also clamps output to prevent clipping)
    ---------------------------------------------------------- */
    c.rgb = clamp(c.rgb * post_gain, 0.0, 1.0);

    if (invert_color)
        c = vec4(vec3(c.a) - c.rgb, c.a);

    c *= opacity;

    return default_post_processing(c);
}
