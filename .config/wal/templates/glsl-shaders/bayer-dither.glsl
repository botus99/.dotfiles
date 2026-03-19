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
   dither pattern opacity (default = 0.33)
   ----------------------------------------------------------
   control how visible the dithering pattern is

   0.0 → smooth gradient (no pattern)
   1.0 → full dithering (pixelated look)
---------------------------------------------------------- */
const float dither_opacity = 0.33;

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

/*   gamma function   */
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
   bayer 4x4 matrix
   ----------------------------------------------------------
   pattern of repeating thresholds used for dithering
   produces a structured, retro, pixel-art-like look
---------------------------------------------------------- */
float bayer4x4(vec2 fragCoord) {
    int x = int(mod(fragCoord.x, 4.0));
    int y = int(mod(fragCoord.y, 4.0));
    int index = x + y * 4;

    float bayer[16] = float[](
        0.0,  8.0,  2.0, 10.0,
       12.0,  4.0, 14.0,  6.0,
        3.0, 11.0,  1.0,  9.0,
       15.0,  7.0, 13.0,  5.0
    );

    /* normalize to 0–1 range */
    return (bayer[index] + 0.5) / 16.0;
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
    ------------------------------------------------------ */
    c.rgb = clamp(c.rgb * pre_gain, 0.0, 1.0);
    c.rgb = gamma_correct(c.rgb, gamma);

    /* ------------------------------------------------------
       contrast push
    ------------------------------------------------------ */
	float l = dot(c.rgb, vec3(0.299,0.587,0.114));
	c.rgb += (c.rgb - l) * contrast_boost;

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
        float dist = color_distance(c.rgb, colors[i]);
        if (dist < best_distance)
        {
            second_distance = best_distance;
            second_index = best_index;
            best_distance = dist;
            best_index = i;
        }
        else if (dist < second_distance)
        {
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
    float ratio = best_distance / (best_distance + second_distance);

    /* ------------------------------------------------------
       perceptual (luminance-based) color weighting
       ------------------------------------------------------
       human vision is more sensitive to green, less to blue

       this shifts the ratio to use perceived brightness
       differences instead of raw RGB distance, helping
       gradients look more natural

       changing the 3 rgb values to 0.333 reverts to linear
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
       bayer dither
    ------------------------------------------------------ */
    float threshold = bayer4x4(gl_FragCoord.xy);

    vec3 dithered_color =
        (threshold > ratio)
        ? colors[best_index]
        : colors[second_index];

    /*   create non-dithered gradient   */
    vec3 base_color = mix(colors[best_index], colors[second_index], ratio);

    /* ------------------------------------------------------
       apply dithering opacity
    ------------------------------------------------------ */
    vec3 quantized_color = mix(base_color, dithered_color, dither_opacity);

    /* ------------------------------------------------------
        apply palette color opacity (final blend)
    ------------------------------------------------------ */
    vec3 finalRGB = c.rgb * (1.0 - color_opacity) + quantized_color * color_opacity;
    vec4 out_color = vec4(finalRGB, c.a);

    /* ------------------------------------------------------
       output brightness (also clamps output to prevent clipping)
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * post_gain, 0.0, 1.0);

    if (invert_color)
        out_color.rgb = out_color.a - out_color.rgb;

    out_color *= opacity;

    return default_post_processing(out_color);
}
