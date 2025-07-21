// heavily based from https://www.shadertoy.com/view/XlsXDB

#version 120
#define saturate(x) clamp(x,0.,1.)
#define rgb(r,g,b) (vec3(r,g,b)/255.)
uniform vec2 resolution;
varying vec2 textureCoord;
uniform float beat;
uniform float time;
uniform sampler2D sampler0;
varying vec2 imageCoord;
uniform vec2 textureSize;
uniform vec2 imageSize;
varying vec4 color;
uniform float ypos = 0;
uniform float velocity = 0;

float rand(float x) { return fract(sin(x) * 71523.5413291); }

float rand(vec2 x) { return rand(dot(x, vec2(13.4251, 15.5128))); }

float noise(vec2 x)
{
    vec2 i = floor(x);
    vec2 f = x - i;
    f *= f*(3.-2.*f);
    return mix(mix(rand(i), rand(i+vec2(1,0)), f.x),
               mix(rand(i+vec2(0,1)), rand(i+vec2(1,1)), f.x), f.y);
}

float fbm(vec2 x)
{
    float r = 0.0, s = 1.0, w = 1.0;
    for (int i=0; i<5; i++)
    {
        s *= 2.0;
        w *= 0.5;
        r += w * noise(s * x);
    }
    return r;
}

float cloud(vec2 uv, float scalex, float scaley, float density, float sharpness, float speed)
{
    return pow(saturate(fbm(vec2(scalex,scaley)*(uv+vec2(velocity,0)))-((0.95+ypos/3)-density)), 1.2-sharpness);
}

vec3 render(vec2 uv)
{
    // sky
    vec3 color = mix(rgb(255,212,166), rgb(204,235,255), uv.y);
    // sun
    vec2 spos = uv - vec2(0., 0.3);
    float sun = exp(-10.*dot(spos,spos));
    vec3 scol = rgb(255,155,102) * sun;
    color += scol;
    // clouds
    vec3 cl1 = mix(rgb(151,138,153), rgb(166,191,224),uv.y);
    float d1 = mix(0.9,0.1,pow(uv.y, 0.7));
    color = mix(color, cl1, cloud(uv,2.,8.,d1,0.4,0.04));
    color = mix(color, vec3(0.9), 8.*cloud(uv,14.,18.,0.9,0.75,0.02) * cloud(uv,2.,5.,0.6,0.15,0.01)*uv.y);
    color = mix(color, vec3(0.8), 5.*cloud(uv,12.,15.,0.9,0.75,0.03) * cloud(uv,2.,8.,0.5,0.0,0.02)*uv.y);
    // post
	if (beat > 0.0) { color *= vec3(0.2,0.13,0.21)*1.34; }
	else { color *= vec3(0.25,0.18,0.26)*1.34; }
    color = mix(0.5*rgb(155,105,101), color, smoothstep(-0.1,sin(beat/2.0 +0.5)* 0.1 + 0.3,uv.y));
    color = pow(color,vec3(1.3));
    return color;
}

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

void main()
{
	vec2 uv = imageCoord;
    uv.x -= 0.5;
    uv.x *= imageSize.x / imageSize.y;
    uv.y = (1+ypos) - uv.y;
	gl_FragColor = vec4(render(uv),1.0) * color;
}