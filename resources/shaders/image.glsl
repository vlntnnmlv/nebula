#pragma language glsl3

uniform vec4 iColor;
uniform bool iMirrorX;
uniform bool iMirrorY;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 realTexCoords = texture_coords; 
    if (iMirrorX)
    {
        realTexCoords.x = 1 - realTexCoords.x;
    }
    if (iMirrorY)
    {
        realTexCoords.y = 1 - realTexCoords.y;
    }

    vec4 texColor = Texel(tex, realTexCoords);

    texColor.a = iColor.a * texColor.a;

    return texColor;
}