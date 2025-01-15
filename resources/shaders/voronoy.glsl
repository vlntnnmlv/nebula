#pragma language glsl3

#define NUM_POINTS 50
#define DIST_MAX 1.414 * NUM_POINTS

extern vec2 iPoints[NUM_POINTS];

uniform vec4 iColor;

float dist(vec2 a, vec2 b)
{
    return sqrt((a.x - b.x)*(a.x - b.x) + (a.y - b.y)*(a.y - b.y));
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 result = iColor;

    float r = -1;
    float r2 = -1;

    float distCur = -1.0;

    float distMin = 100.0;
    float distMin2 = 100.0;

    float distAcc = 0.0;

    for (int i = 0; i < NUM_POINTS; i++)
    {
        distCur = dist(iPoints[i], texture_coords);
        distAcc += distCur;
        if (distCur < distMin)
        {
            distMin = distCur;
            r = i;
        }
        else if (distCur < distMin2)
        {
            distMin2 = distCur;
            r2 = i;
        }
    }

    // float d = dist(texture_coords, iPoints[int(r)]);
    // float acc = dist(iPoints[int(r)], iPoints[int(r2)]);
    // result = vec4(vec3(d/acc), 1);

    float v = smoothstep(r, 0.0, NUM_POINTS - 1.0);
    result = vec4(vec3((r + 1.0)/NUM_POINTS, 0.4, 0.34), 1.0);

    // for (int i = 0; i < NUM_POINTS; i++)
    // {
    //     if (dist(iPoints[i], texture_coords) < 0.005)
    //     {
    //         result = vec4(1,0,0,1);
    //     }
    // }

    return result;
}