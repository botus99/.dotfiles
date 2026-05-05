#version 330 core

uniform float opacity;
uniform float time;
uniform bool invert_color;
uniform sampler2D tex;
uniform int film_stock; // 0 = Kodak, 1 = Fuji, 2 = Neutral
uniform float iso;      // e.g. 100–1600

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
const float post_gain  = 2.0;

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
const float dither_opacity = 0.667;

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
float color_distance(vec3 c, vec3 p, float p_len2) {
    return p_len2 - 2.0 * dot(c, p);
}

/* ----------------------------------------------------------
   srgb -> linear rgb (default = 2.2)
   ----------------------------------------------------------
   convert display space (non-linear) to linear space

   most color math assumes linear light, so this improves
   the accuracy of color conversions
---------------------------------------------------------- */
vec3 srgb_to_linear(vec3 c) {
    return pow(c, vec3(2.2));
}

/* ----------------------------------------------------------
   rgb -> oklab
   ----------------------------------------------------------
   oklab is a perceptual color space for image processing
   it can predict perceived lightness, chroma and hue well
   it is simple, well-behaved numerically, and easy to adopt

   more info: (https://bottosson.github.io/posts/oklab)
---------------------------------------------------------- */
vec3 rgb_to_oklab(vec3 c) {
    /* step 1: convert to linear rgb */
    vec3 lrgb = srgb_to_linear(c);

    /* step 2: convert to lms space */
    float l = 0.4122214708 * lrgb.r + 0.5363325363 * lrgb.g + 0.0514459929 * lrgb.b;
    float m = 0.2119034982 * lrgb.r + 0.6806995451 * lrgb.g + 0.1073969566 * lrgb.b;
    float s = 0.0883024619 * lrgb.r + 0.2817188376 * lrgb.g + 0.6299787005 * lrgb.b;

    /* step 3: apply cube root */
    l = pow(l, 1.0/3.0);
    m = pow(m, 1.0/3.0);
    s = pow(s, 1.0/3.0);

    /* step 4: convert to oklab */
    return vec3(
        0.2104542553*l + 0.7936177850*m - 0.0040720468*s,
        1.9779984951*l - 2.4285922050*m + 0.4505937099*s,
        0.0259040371*l + 0.7827717662*m - 0.8086757660*s
    );
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
// float random(float seed_change) {
//     /*   create a seed based on pixel position   */
//     vec2 seed = gl_FragCoord.xy + sin(seed_change);
//     /*   scramble the seed using trig + division   */
//     float scrambled = sin(mod(seed.x / cos(seed.y), 5.0) * 10000.0);
//     /*   dot product mixes values into a single float   */
//     float mixed = dot(vec2(scrambled), vec2(1.1, 12.2));
//     /*   fract keeps only the decimal part → 0.0 to 1.0   */
//     return fract(mixed);
// }

float random(float seed_change) {
    vec2 p = gl_FragCoord.xy;

    /* animated warp */
    p += vec2(
        sin(seed_change * 0.7) * 2.0,
        cos(seed_change * 0.9) * 2.0
    );

    /* mild nonlinear distortion */
    p += sin(p.yx * 0.05);

    float n = dot(p, vec2(12.9898, 78.233));

    return fract(sin(n) * 43758.5453);
}

// float random(float seed_change) {
//     vec2 p = gl_FragCoord.xy;

//     p += vec2(
//         sin(seed_change * 1.3),
//         cos(seed_change * 1.7)
//     );

//     float n = dot(p, vec2(12.9898, 78.233));

//     return fract(sin(n) * 43758.5453);
// }

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
       ------------------------------------------------------
       adjust how colors are mapped to the palette
       BEFORE color quantizing
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * pre_gain, 0.0, 1.0);
    out_color.rgb = gamma_correct(out_color.rgb, gamma);

    /* ------------------------------------------------------
       contrast push
    ------------------------------------------------------ */
	float l = dot(out_color.rgb, vec3(0.299,0.587,0.114));
	out_color.rgb += (out_color.rgb - l) * contrast_boost;

    /* ------------------------------------------------------
       pywal colors
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
       precompute squared lengths
       ------------------------------------------------------
       calculates the color distance upfront instead of
       repeating the same calculation for every palette color

       helps shader performance by avoiding unnecessary
       repeated math, especially since this code runs for
       every pixel on the screen
    ------------------------------------------------------ */
    vec3 palette_lab[16];
    float palette_len2[16];

    for (int i = 0; i < 16; i++) {
        palette_lab[i] = rgb_to_oklab(colors[i]);
        palette_len2[i] = dot(palette_lab[i], palette_lab[i]);
    }

    vec3 pixel_lab = rgb_to_oklab(out_color.rgb);

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
        float dist = palette_len2[i] - 2.0 * dot(pixel_lab, palette_lab[i]);
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
    float palette_proximity = smoothstep(0.0, 0.01, best_distance);

    /*   bias toward "unity" ratio (0.5) when very close   */
    ratio = mix(0.5, ratio, palette_proximity);

    /*   smooth transitions to avoid harsh artifacts   */
    // ratio = smoothstep(0.0, 1.0, ratio);

    /* ------------------------------------------------------
    film grain (multi-scale, luminance-aware)
    ------------------------------------------------------ */
    /* base luminance */
   //  float luminance = dot(out_color.rgb, vec3(0.299,0.587,0.114));
    /* oklab luminance */
    float luminance = pixel_lab.x;

    /* defaults (neutral) */
    float grain_size   = 1.0;
    float grain_amount = 1.0;
    float chroma_amt   = 0.0;
    float tonal_bias   = 1.2;

    if (film_stock == 0) {
        /* Kodak */
        grain_size   = 0.8;
        grain_amount = 0.7;
        chroma_amt   = 0.05;
        tonal_bias   = 1.5;
    }
    else if (film_stock == 1) {
        /* Fuji */
        grain_size   = 1.3;
        grain_amount = 1.2;
        chroma_amt   = 0.12;
        tonal_bias   = 1.1;
    }

    /* luminance response */
    float grain_strength = pow(1.0 - luminance, tonal_bias);



    /* normalize ISO roughly */
    float iso_norm = clamp((iso - 100.0) / 1500.0, 0.0, 1.0);

    /* grain gets stronger + larger */
    grain_amount *= mix(0.6, 2.0, iso_norm);
    grain_size   *= mix(0.8, 1.8, iso_norm);

    /* high ISO = more chroma noise */
    chroma_amt   *= mix(0.5, 2.0, iso_norm);

    /* time quantization (film-like cadence) */
    float t = floor(time * 1.0) / 24.0;

    /* scaled coords (grain size control) */
    vec2 p = gl_FragCoord.xy * grain_size;

    /* fine + coarse layers */
    float g1 = random(t + dot(p, vec2(1.0, 57.0)));
    float g2 = random(t + dot(floor(p * 0.5), vec2(13.0, 71.0)));

    float grain = mix(g1, g2, 0.35);

    /* center */
    grain = grain - 0.5;

    /* luminance shaping */
    grain *= grain_strength * grain_amount;

    /* subtle chroma grain */
    float chroma = (random(t + dot(p, vec2(91.0,17.0))) - 0.5) * chroma_amt;

    /* final combined */
    float randomness = clamp(grain + chroma + 0.5, 0.0, 1.0);

    /* reduce grain when already close to palette */
    randomness = smoothstep(0.2, 0.9, randomness);

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
       "4.00 + 0.48" for a happy medium
       "5.00 + 0.45" for a tamer, less noisy version
    ------------------------------------------------------ */
    // randomness = randomness * 3 + 0.33;
    randomness = mix(randomness, randomness * 4, 0.5);
    // randomness = smoothstep(0.2, 0.8, randomness);

    /* ------------------------------------------------------
       final color selection
       ------------------------------------------------------
       compare random value to ratio to decide which
       palette color a pixel becomes
    ------------------------------------------------------ */
    if (randomness > ratio)
        out_color.rgb = colors[best_index];
    else
        out_color.rgb = colors[second_index];

    /* ------------------------------------------------------
       final color blend
       ------------------------------------------------------
       mix the dithered result with a smooth gradient
       between the two palette colors, reducing harsh
       grain and flickering edges
    ------------------------------------------------------ */
    out_color.rgb = mix(mix(colors[best_index], colors[second_index], ratio), out_color.rgb, dither_opacity);

    /* ------------------------------------------------------
       output brightness (also clamps output to prevent clipping)
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * post_gain, 0.0, 1.0);

    if (invert_color)
        out_color = vec4(vec3(out_color.a) - out_color.rgb, out_color.a);

    out_color *= opacity;

    return default_post_processing(out_color);
}
