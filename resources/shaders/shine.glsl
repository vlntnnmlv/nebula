#pragma language glsl3

uniform float iTime;
uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    iTime;

    vec4 texcolor = Texel(tex, texture_coords);

    vec2 uvC = texture_coords - vec2(0.5);

    float dist = sqrt(uvC.x * uvC.x + uvC.y * uvC.y);
    float distN = smoothstep(0, 0.5, dist);
    float distS = (sin(distN * 10 + iTime * 5.0) + 1.0) / 2.0;

    float a = (1 - distN) + (distS * (1 - distN));

    vec4 result = iColor;

    result.a = a;

    return result;
}