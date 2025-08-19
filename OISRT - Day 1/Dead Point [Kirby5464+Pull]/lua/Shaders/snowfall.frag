#version 120

// Taken from https://www.shadertoy.com/view/4l2SW3
// Edited for nITG modding purposes ~Kirby

// SnowScreen (superposition of blobs in displaced-grid voronoi-cells) by Jakob Thomsen
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#define pi 3.14159265

varying vec2 imageCoord;

uniform float time;
uniform float amt;
uniform float blur;

uniform vec2 textureSize;
uniform vec2 imageSize;

uniform sampler2D sampler0;

vec2 img2tex( vec2 v ) { return clamp(v, 0.0 + 1.0 / imageSize.x, 1.0 - 1.0 / imageSize.x) / textureSize * imageSize; }

float T;

// iq's hash function from https://www.shadertoy.com/view/MslGD8
vec2 hash( vec2 p ) { p=vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))); return fract(sin(p)*18.5453); }

float simplegridnoise(vec2 v)
{
    float s = 1. / 256.;
    vec2 fl = floor(v), fr = fract(v);
    float mindist = 1e9;
    for(int y = -1; y <= 1; y++)
        for(int x = -1; x <= 1; x++)
        {
            vec2 offset = vec2(x, y);
            vec2 pos = .5 + .5 * cos(2. * pi * (T*.1 + hash(fl+offset)) + vec2(0,1.6));
            mindist = min(mindist, length(pos+offset -fr));
        }

    return mindist;
}

float blobnoise(vec2 v, float s)
{
    return .5 + .5 * cos(pi * clamp(simplegridnoise(v)*2., 0., 1.));
}

float fractalblobnoise(vec2 v, float s)
{
    float val = 0.;
    const float n = 4.;
    for(float i = 0.; i < n; i++)
        //val += 1.0 / (i + 1.0) * blobnoise((i + 1.0) * v + vec2(0.0, iTime * 1.0), s);
    	val += ((0.3 * ((i + 1.) * 0.4)) / ((i + 1.) * 0.4)) * blobnoise(exp2(i) * v + vec2(0, T), s);

    return val;
}

void main()
{
    T = time;

    vec2 r = vec2(1.0, imageSize / textureSize);
    vec2 uv = imageCoord;
    float val = fractalblobnoise(r * uv * amt, blur);
    //float val = fractalblobnoise(r * uv * 40.0, 1.25); // more snowflakes
    //float val = blobnoise(r * uv * 10.0, 5.0);
    // gl_FragColor = vec4(vec3(val), 1.0);
    gl_FragColor = mix(texture2D(sampler0, img2tex(uv)), vec4(1.0), vec4(val));
}
