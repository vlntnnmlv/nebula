#pragma language glsl3

uniform vec4 iColor;
uniform vec2 iResolution;
uniform vec2 iPosition;
uniform vec2 iDirection;
uniform float iRadius;

float dist(vec2 a, vec2 b)
{
    float dx = a.x - b.x;
    float dy = a.y - b.y;
    return sqrt(dx*dx + dy*dy);
}

vec4 mixColor(vec4 a, vec4 b)
{
    return vec4(a.r * a.a + b.r * b.a, a.g * a.a + b.g * b.a, a.b * a.a + b.b * b.a, 1.0);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    iColor;
    iDirection;

    vec2 uv = texture_coords;
    vec2 uvWorld = vec2(uv.x * iResolution.x, uv.y * iResolution.y);

    float d = dist(iPosition, uvWorld);
    vec4 textureColor = Texel(tex, texture_coords);
    vec4 effectColor = vec4(1.0, 0.0, 0.0, 1.0 - smoothstep(0, iRadius, d));

    if (d < iRadius)
    {
        return mixColor(effectColor, textureColor);
    }
    else
    {
        return textureColor;
    }
}