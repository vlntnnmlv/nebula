#pragma language glsl3

uniform vec4 iColor;

uniform float iDepth;
uniform float iScale;
uniform vec2 iOffset;
uniform float iTime;

float v(vec2 c)
{
    return c.x*c.x + c.y*c.y;
}

float f(vec2 z, vec2 c)
{
    return v(z)*v(z) + v(c);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    float scale = iScale;
    vec2 offset = iOffset;

    iTime;
    iColor;

    vec2 uvC = texture_coords - vec2(0.5);

    vec2 uv = uvC * scale;
    uv += offset * sqrt(scale);

    vec2 p = vec2(0.0);
    float xtemp;
 
    int it = 0;
    while (p.x*p.x + p.y*p.y < 4.0 && it < iDepth)
    {
        xtemp = p.x*p.x - p.y*p.y + uv.x;
        p.y = 2*p.x*p.y + uv.y;
        p.x = xtemp;
        it += 1;
    }

    vec4 result = vec4(it/iDepth, 0.5 - it/iDepth, 0.0, 1.0);

    return result;
}