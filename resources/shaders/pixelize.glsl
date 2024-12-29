#pragma language glsl3

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 steps = texture_coords / 0.0014;

    vec2 t = vec2(int(steps.x) / 700.0, int(steps.y) / 700.0);

    vec4 texcolor = Texel(tex, t);
    vec4 result = texcolor * color;

    return result;
}