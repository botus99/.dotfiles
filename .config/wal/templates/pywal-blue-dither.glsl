#version 330 core

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

in vec2 texcoord;

vec4 default_post_processing(vec4 c);

/* ----------------------------------------------------------
   Perceptual distance
---------------------------------------------------------- */
float color_distance(vec3 a, vec3 b) {
    vec3 diff = a - b;
    vec3 weight = vec3(0.299, 0.587, 0.114);
    return dot(diff * weight, diff);
}

/* ----------------------------------------------------------
   Interleaved Gradient Noise (blue-noise style, stable)
---------------------------------------------------------- */
float blue_noise(vec2 p) {
    return fract(52.9829189 * fract(dot(p, vec2(0.06711056, 0.00583715))));
}

/* ----------------------------------------------------------
   Main shader
---------------------------------------------------------- */
vec4 window_shader() {

    vec2 texsize = textureSize(tex, 0);
    vec4 c = texture(tex, texcoord / texsize);

    vec3 colors[16];

    colors[0]  = vec3({color0.red},  {color0.green},  {color0.blue});
    colors[1]  = vec3({color1.red},  {color1.green},  {color1.blue});
    colors[2]  = vec3({color2.red},  {color2.green},  {color2.blue});
    colors[3]  = vec3({color3.red},  {color3.green},  {color3.blue});
    colors[4]  = vec3({color4.red},  {color4.green},  {color4.blue});
    colors[5]  = vec3({color5.red},  {color5.green},  {color5.blue});
    colors[6]  = vec3({color6.red},  {color6.green},  {color6.blue});
    colors[7]  = vec3({color7.red},  {color7.green},  {color7.blue});
    colors[8]  = vec3({color8.red},  {color8.green},  {color8.blue});
    colors[9]  = vec3({color9.red},  {color9.green},  {color9.blue});
    colors[10] = vec3({color10.red}, {color10.green}, {color10.blue});
    colors[11] = vec3({color11.red}, {color11.green}, {color11.blue});
    colors[12] = vec3({color12.red}, {color12.green}, {color12.blue});
    colors[13] = vec3({color13.red}, {color13.green}, {color13.blue});
    colors[14] = vec3({color14.red}, {color14.green}, {color14.blue});
    colors[15] = vec3({color15.red}, {color15.green}, {color15.blue});

    /* ------------------------------------------------------
       Find two closest colors
    ------------------------------------------------------ */
    float bestDist = 1e9;
    float secondDist = 1e9;
    int bestIndex = 0;
    int secondIndex = 0;

    for (int i = 0; i < 16; i++) {
        float dist = color_distance(c.rgb, colors[i]);

        if (dist < bestDist) {
            secondDist = bestDist;
            secondIndex = bestIndex;
            bestDist = dist;
            bestIndex = i;
        }
        else if (dist < secondDist) {
            secondDist = dist;
            secondIndex = i;
        }
    }

    /* ------------------------------------------------------
       Blue-noise dithering
    ------------------------------------------------------ */
    float ratio = bestDist / (bestDist + secondDist + 1e-6);
    float threshold = blue_noise(gl_FragCoord.xy);

    vec3 finalColor = (threshold < ratio)
        ? colors[secondIndex]
        : colors[bestIndex];

    vec4 outColor = vec4(finalColor, c.a);

    if (invert_color)
        outColor.rgb = outColor.a - outColor.rgb;

    outColor *= opacity;

    return default_post_processing(outColor);
}
