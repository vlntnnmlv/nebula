#pragma language glsl3

uniform float iTime;
uniform vec4 iColor;

float hyper(float x)
{
    return -((x-1.0)*(x-1.0)) + 1.0;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    iTime;

    vec4 texcolor = Texel(tex, texture_coords);

    vec2 uvC = texture_coords - vec2(0.5);

    float dist = sqrt(uvC.x * uvC.x + uvC.y * uvC.y);
    float distN = smoothstep(0, 0.5, dist);
    float distS = sin(hyper(1 - distN) * 3.14 + iTime * 5.0); //(sin(distN + iTime * 5.0) + 1.0) / 2.0;

    float a = distS * (1.0 - distN);

    vec4 result = iColor;

    result.a = a;

    return result;
}