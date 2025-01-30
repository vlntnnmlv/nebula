#pragma language glsl3

uniform vec4 iColor;
uniform vec2 iTexSize;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 realTexCoords = texture_coords; 

    vec4 texColor = Texel(tex, realTexCoords);

    texColor.a = iColor.a * texColor.a;

    return texColor;
}