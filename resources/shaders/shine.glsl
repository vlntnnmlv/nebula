#pragma language glsl3

uniform float iTime;
uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texcolor = Texel(tex, texture_coords);

    vec2 uvC = texture_coords - vec2(0.5);

    float dist = sqrt(uvC.x * uvC.x + uvC.y * uvC.y);
    float v = smoothstep(-2.0, 2.0, sin(dist * 100.0 - iTime * 5.0));

    v = smoothstep(-1.0, v, dist * 2.0) * smoothstep(0.5, 0.0, dist);

    vec4 result = iColor * color * v;

    if (texcolor.a <= 0.0 || v >= 1.0)
    {
        result.a = smoothstep(0.0, 1.0, texcolor.a);
    }

    return result;
}