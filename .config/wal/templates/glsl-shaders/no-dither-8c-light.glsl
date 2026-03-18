#version 330 core

uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

in vec2 texcoord;

vec4 default_post_processing(vec4 c);

/* ----------------------------------------------------------
   color distance
---------------------------------------------------------- */
float color_distance(vec3 c, vec3 p)
{
    return dot(p, p) - 2.0 * dot(c, p);
}

/* ----------------------------------------------------------
   main shader
---------------------------------------------------------- */
vec4 window_shader() {
    vec2 texsize = textureSize(tex, 0);
    vec4 c = texture(tex, texcoord / texsize);
    vec3 colors[8];

    /* ------------------------------------------------------
       pywal colors
    ------------------------------------------------------ */
    colors[0] = vec3({color8.red}, {color8.green}, {color8.blue});
    colors[1] = vec3({color1.red}, {color1.green}, {color1.blue});
    colors[2] = vec3({color2.red}, {color2.green}, {color2.blue});
    colors[3] = vec3({color3.red}, {color3.green}, {color3.blue});
    colors[4] = vec3({color12.red}, {color12.green}, {color12.blue});
    colors[5] = vec3({color13.red}, {color13.green}, {color13.blue});
    colors[6] = vec3({color14.red}, {color14.green}, {color14.blue});
    colors[7] = vec3({color15.red}, {color15.green}, {color15.blue});

    /* ------------------------------------------------------
       find closest palette color
    ------------------------------------------------------ */
    float bestDist = 1e9;
    int bestIndex = 0;

    for (int i = 0; i < 8; i++) {
        float dist = color_distance(c.rgb, colors[i]);
        if (dist < bestDist) {
            bestDist = dist;
            bestIndex = i;
        }
    }

    vec4 outColor = vec4(colors[bestIndex], c.a);

    if (invert_color)
        outColor.rgb = outColor.a - outColor.rgb;

    outColor *= opacity;

    return default_post_processing(outColor);
}
