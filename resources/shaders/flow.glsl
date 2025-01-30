#pragma language glsl3

uniform vec4 iColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 t = vec2(texture_coords.x, texture_coords.y);
    return vec4(1.0, 0.0, 0.0, 0.0);
}