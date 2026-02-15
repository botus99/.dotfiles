#version 330 core

uniform float opacity;
uniform float time;
uniform bool invert_color;
uniform sampler2D tex;

in vec2 texcoord;

vec4 default_post_processing(vec4 c);

float sin_rand() {
    return sin(gl_FragCoord.x + cos(gl_FragCoord.y));
}

float random(float seedChange) {
    vec2 seed = gl_FragCoord.xy + sin(seedChange);
    return fract(dot(vec2(sin(mod(seed.x / cos(seed.y), 5.0) * 10000.0)), vec2(1.1, 12.2)));
}

/* ----------------------------------------------------------
   Main shader
---------------------------------------------------------- */
vec4 window_shader() {
    vec2 texsize = textureSize(tex, 0);
    vec4 c = texture2D(tex, texcoord / texsize, 0);
    vec4 d = c;
    vec3 colors[16];

/* ----------------------------------------------------------
   pywal-colors
---------------------------------------------------------- */
    colors[0] = vec3({color0.red},  {color0.green},  {color0.blue});
    colors[1] = vec3({color1.red},  {color1.green},  {color1.blue});
    colors[2] = vec3({color2.red},  {color2.green},  {color2.blue});
    colors[3] = vec3({color3.red},  {color3.green},  {color3.blue});
    colors[4] = vec3({color4.red},  {color4.green},  {color4.blue});
    colors[5] = vec3({color5.red},  {color5.green},  {color5.blue});
    colors[6] = vec3({color6.red},  {color6.green},  {color6.blue});
    colors[7] = vec3({color7.red},  {color7.green},  {color7.blue});
    colors[8] = vec3({color8.red},  {color8.green},  {color8.blue});
    colors[9] = vec3({color9.red},  {color9.green},  {color9.blue});
    colors[10] = vec3({color10.red},  {color10.green},  {color10.blue});
    colors[11] = vec3({color11.red},  {color11.green},  {color11.blue});
    colors[12] = vec3({color12.red},  {color12.green},  {color12.blue});
    colors[13] = vec3({color13.red},  {color13.green},  {color13.blue});
    colors[14] = vec3({color14.red},  {color14.green},  {color14.blue});
    colors[15] = vec3({color15.red},  {color15.green},  {color15.blue});

    float mindist = 100.0;
    int minind = 0;
    float mindist2 = 100.0;
    int minind2 = 0;
    for (int i = 0; i < 16; i++) {
        float dist = length(c.xyz - colors[i]);
        if (dist < mindist) {
            mindist2 = mindist;
            mindist = dist;
            minind2 = minind;
            minind = i;
        }
    }
    float ratio = mindist / (mindist + mindist2);
    float r = random(1.0) * 0.4 + 0.25;
    if (r > ratio)
        c.xyz = colors[minind];
    else 
        c.xyz = colors[minind2];

    c.xyz = mix(mix(colors[minind], colors[minind2], ratio), c.xyz, 0.5);

    if (invert_color)
        c = vec4(vec3(c.a, c.a, c.a) - vec3(c), c.a);
    c *= opacity;
    return default_post_processing(c);
}
