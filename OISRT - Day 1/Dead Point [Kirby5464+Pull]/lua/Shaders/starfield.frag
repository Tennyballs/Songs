#version 120

// original shader from https://www.shadertoy.com/view/wsKXRK
// edited and modified for nITG use hehe ~Kirby

#define PI 3.14159265

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform float time;
uniform float speed;
uniform float shift;

uniform float hscale;
uniform float vscale;

uniform vec2 resolution;
uniform vec2 textureSize;
uniform vec2 imageSize;

float vDrop(vec2 uv,float t)
{
    uv.x = uv.x*128.0;						// H-Count
    float dx = fract(uv.x);
    uv.x = floor(uv.x);
    uv.y *= 0.05;							// stretch
    float o=sin(uv.x*215.4);				// offset
    float s=cos(uv.x*33.1)*speed;			// speed
    float trail = mix(95.0,35.0,s);			// trail length
    float yv = fract(uv.y + t*s + o) * trail;
    yv = 1.0/yv;
    yv = smoothstep(0.0,1.0,yv*yv);
    yv = sin(yv*PI)*(s*5.0);
    float d2 = sin(dx*PI);
    return yv*(d2*d2);
}

void main()
{
	vec2 center = vec2(hscale,vscale) * 0.5;

    vec2 p = imageCoord - (center + shift) * textureSize / imageSize;
    float d = length(p)+0.1;
	p = vec2(atan(p.x, p.y) / PI, 2.5 / d);
    float t = time*0.4;
    vec3 col = vec3(0,1,1) * vDrop(p,t);
    col = vec3(1,1,1) * vDrop(p,t+0.33);
	gl_FragColor = vec4(col*(d*d), 1.0);
}
