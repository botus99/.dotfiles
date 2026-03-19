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
   contrast boost (default = 0.0)
   ----------------------------------------------------------
   push colors toward their nearest palette color
   BEFORE color quantization happens
---------------------------------------------------------- */
const float contrast_boost = 0.0;

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
   oklab is a perceptual color space
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
       precompute palette in oklab space
       ------------------------------------------------------
       calculates the color distance upfront instead of
       repeating the same calculation for every palette color
   ------------------------------------------------------ */
   vec3 palette_lab[16];
   for (int i = 0; i < 16; i++) {
      palette_lab[i] = rgb_to_oklab(colors[i]);
   }

    /* ------------------------------------------------------
       precompute palette squared lengths (oklab)
       ------------------------------------------------------
       calculate dot(color, color) once for each pywal color
    ------------------------------------------------------ */
    float palette_len2[16];
    for (int i = 0; i < 16; i++) {
        palette_len2[i] = dot(palette_lab[i], palette_lab[i]);
    }

    /* ------------------------------------------------------
       find closest palette color
       ------------------------------------------------------
       convert pixel and palette colors into oklab
       then compare the distances
    ------------------------------------------------------ */
    vec3 pixel_lab = rgb_to_oklab(c.rgb);

    float best_distance = 1e20;
    int best_index = 0;

    for (int i = 0; i < 16; i++) {
        /*   compute distance from current pixel to palette color   */
        float dist = palette_len2[i] - 2.0 * dot(pixel_lab, palette_lab[i]);
        if (dist < best_distance) {
            best_distance = dist;
            best_index = i;
        }
    }

    /* ------------------------------------------------------
       final color blend
    ------------------------------------------------------ */
    vec4 out_color = vec4(colors[best_index], c.a);

    vec3 finalRGB = c.rgb * (1.0 - color_opacity) + out_color.rgb * color_opacity;
    out_color.rgb = finalRGB;

    if (invert_color)
        out_color.rgb = out_color.a - out_color.rgb;

    /* ------------------------------------------------------
       output brightness (also clamps to prevent clipping)
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * post_gain, 0.0, 1.0);

    out_color *= opacity;

    return default_post_processing(out_color);
}
