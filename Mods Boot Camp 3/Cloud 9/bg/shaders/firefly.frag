#version 120
#define PI 3.14159265
#define rnd(r) fract(4579.0 * sin(1957.0 * (r)))
varying vec3 position;
varying vec3 normal;
varying vec4 color;
varying vec2 textureCoord;
varying vec2 imageCoord;

uniform float time;
uniform float beat;
uniform vec2 resolution;
uniform vec2 textureSize;
uniform vec2 imageSize;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 perspectiveMatrix;
uniform mat4 textureMatrix;
uniform sampler2D sampler0;
uniform sampler2D sampler1;
//uniform sampler2D randomNoise;

float rand( vec2 co ) { return fract(sin(dot(co.xy,vec2(12.9898,78.233))) * 43758.5453); }
vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void mainImage(out vec4 col, in vec2 pos)
{
    float t = beat;
    pos /= imageSize.x;
    col = vec4(0.0);
    
    for (float i = 0.0; i < 20.0; i += 1.0)
    {
        float r = (0.5 + 0.5 * rnd(i)) * sin(i/1000.);
        vec2 point = rnd(i + vec2(1.0, 2.0));
        vec2 veloc =  rnd(i - vec2(3000.0, 90.0));
        
        vec2 point_real = fract(point + veloc * t * 0.05);
        float dist = length(point_real - pos) / r;

        if (dist < 1.0)
        {
            col += color - dist;
        }
    }
}

void main()
{
	mainImage(gl_FragColor.rgba,gl_FragCoord.xy);
}