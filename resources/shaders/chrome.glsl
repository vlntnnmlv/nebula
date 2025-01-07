#pragma language glsl3

uniform float iTime;
uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    iColor;
    vec4 texcolor = Texel(tex, texture_coords);

    vec2 size = textureSize(tex, 1);
    vec2 uv = texture_coords / size;

    vec4 effectColor = vec4(texture_coords.x, texture_coords.y, (sin(iTime) + 1.0) / 2.0, 1.0) / 5.0;
    vec4 result = texcolor * color + effectColor;
    if (texcolor.a <= 0.0)
    {
        result.a = 0.0;
    }

    return result;
}