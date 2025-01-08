#pragma language glsl3

uniform vec2 iScale;
uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    iColor;

    vec2 steps = texture_coords * iScale;

    vec2 t = vec2(int(steps.x) / iScale.x, int(steps.y) / iScale.y);

    vec4 texcolor = Texel(tex, t);
    vec4 result = texcolor * color;

    return result;
}