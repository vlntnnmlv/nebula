#pragma language glsl3

uniform float iScale;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 steps = texture_coords * iScale;

    vec2 t = vec2(int(steps.x) / iScale, int(steps.y) / iScale);

    vec4 texcolor = Texel(tex, t);
    vec4 result = texcolor * color;

    return result;
}