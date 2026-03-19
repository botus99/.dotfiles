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
const float gamma =2.2;

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
   color distance
   ----------------------------------------------------------
   compute how close a color is to a pywal color entry

   lower value = better match
---------------------------------------------------------- */
float color_distance(vec3 c, vec3 p, float pl) {
    return pl - 2.0 * dot(c, p);
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
    vec2 texsize = textureSize(tex, 0);
    vec4 c = texture(tex, texcoord / texsize);
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
    vec3 colors[8] = vec3[8](
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
    ------------------------------------------------------ */
    float palette_len2[8];
    for (int i = 0; i < 8; i++)
        palette_len2[i] = dot(colors[i], colors[i]);

    /* ------------------------------------------------------
       find closest palette color
    ------------------------------------------------------ */
    vec3 color = out_color.rgb;
    float best_distance = 1e20;
    int best_index = 0;

    for (int i = 0; i < 8; i++) {
        float dist = color_distance(color, colors[i], palette_len2[i]);
        if (dist < best_distance) {
            best_distance = dist;
            best_index = i;
        }
    }

    /* ------------------------------------------------------
       final color blend
    ------------------------------------------------------ */
    out_color.rgb = out_color.rgb * (1.0 - color_opacity) + colors[best_index] * color_opacity;

    /* ------------------------------------------------------
       output brightness (also clamps output to prevent clipping)
    ------------------------------------------------------ */
    out_color.rgb = clamp(out_color.rgb * post_gain, 0.0, 1.0);

    if (invert_color)
        out_color.rgb = out_color.a - out_color.rgb;

    out_color *= opacity;

    return default_post_processing(out_color);
}
