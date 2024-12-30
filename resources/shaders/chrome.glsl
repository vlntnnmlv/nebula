#pragma language glsl3

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texcolor = Texel(tex, texture_coords);

    vec4 effectColor = vec4(texture_coords.x, texture_coords.y, 0.0, 1.0) / 5.0;

    vec4 result = texcolor * color + effectColor;
    if (texcolor.a <= 0.0)
    {
        result.a = 0.0;
    }

    return result;
}