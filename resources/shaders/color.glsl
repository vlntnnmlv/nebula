#pragma language glsl3

uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    iColor;

    return vec4(texture_coords, 0.0, 1.0);
}