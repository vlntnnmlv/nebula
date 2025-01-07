#pragma language glsl3

uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    return iColor;
}