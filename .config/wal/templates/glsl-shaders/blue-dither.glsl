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
   dither pattern opacity (default = 0.25)
   ----------------------------------------------------------
   control how visible the dithering pattern is

   0.0 → smooth gradient (no pattern)
   1.0 → full dithering (pixelated look)
---------------------------------------------------------- */
const float dither_opacity = 0.25;

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
   works after pre_gain brightness to adjust color quantization

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
   interleaved gradient noise (blue-noise style)
   ----------------------------------------------------------
   this is a lightweight and pseudo-random function
   it is designed to create "blue-noise-like" patterns

   blue noise does not repeat grids like bayer, and
   is kind of an in-between of the bayer and random
   shaders

   This function:
   - takes a 2D coordinate (pixel position)
   - hashes it into a stable value between 0.0–1.0
---------------------------------------------------------- */
float blue_noise(vec2 p) {
    /* dot() mixes x/y into a single value */
    float d = dot(p, vec2(0.06711056, 0.00583715));
    /* fract breaks up large patterns */
    float scrambled = fract(d);
    /* multiply and fract again to spread values into 0–1 */
    return fract(52.9829189 * scrambled);
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

    /* ------------------------------------------------------
       pre-processing (brightness + gamma)
       ------------------------------------------------------
       adjust how colors are mapped to the palette
       BEFORE color quantizing
    ------------------------------------------------------ */
    c.rgb = clamp(c.rgb * pre_gain, 0.0, 1.0);
    c.rgb = gamma_correct(c.rgb, gamma);

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
       contrast push
    ------------------------------------------------------ */
    vec3 primary = colors[best_index];
    c.rgb = mix(c.rgb, primary, contrast_boost);

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

    /*   residual error shaping   */
    vec3 err = c.rgb - colors[best_index];

    /*   perceptual weights   */
    ratio += dot(err, vec3(0.299, 0.587, 0.114));

    /*   reduce noise in solid, flat color areas   */
    ratio = smoothstep(0.0, 1.0, ratio);

    /* ------------------------------------------------------
       jitter / offest
       ------------------------------------------------------
       noise functions can sometimes produce repeating
       patterns stripes, waves, or other artifacts when
       sampled directly from screen coordinates

       to shuffle things around, offset the sampling
       position using a value derived from "ratio"

       ratio changes per pixel based on color distance
    ------------------------------------------------------ */
    vec2 jitter = vec2(ratio, 1.0 - ratio);

    /* ------------------------------------------------------
       blue-noise dither
       ------------------------------------------------------
       sample the blue-noise function using the pixel
       position (including the the jitter offset)

       the multiplier (17.0) scales the dither grid offset to
       make the effect noticeable without being chaotic.
    ------------------------------------------------------ */
    float threshold = blue_noise(gl_FragCoord.xy + jitter * 17.0);

    /* ------------------------------------------------------
       final color selection
       ------------------------------------------------------
       compare noise (threshold) against ratio to decide
       which of the two palette colors to use

       threshold < ratio → pick second color
       threshold ≥ ratio → pick best color
    ------------------------------------------------------ */
    vec3 dither_color =
        (threshold < ratio)
        ? colors[second_index]
        : colors[best_index];

    /* ------------------------------------------------------
       apply dithering opacity
    ------------------------------------------------------ */
    vec3 quantized_color = mix(colors[best_index], dither_color, dither_opacity);

    /* ------------------------------------------------------
       apply palette color opacity (final blend)
    ------------------------------------------------------ */
    vec3 final_rgb = c.rgb * (1.0 - color_opacity) + quantized_color * color_opacity;
    vec4 out_color = vec4(final_rgb, c.a);

    /* ------------------------------------------------------
       output brightness (also clamps output to prevent clipping)
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * post_gain, 0.0, 1.0);

    if (invert_color)
        out_color.rgb = out_color.a - out_color.rgb;

    out_color *= opacity;

    return default_post_processing(out_color);
}