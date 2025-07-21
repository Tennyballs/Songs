#version 120

// taken from https://www.shadertoy.com/view/XtjSRG

#define freqStart -1.0
#define freqInterval 0.1
#define sampleSize 0.02

uniform float intensity;
uniform float xaxis;
uniform float yaxis;

varying vec2 imageCoord;
uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;
uniform sampler2D sampler1;

void main()
{

	vec2 xy = imageCoord / textureSize * imageSize;

	//set offsets
    vec2 rOffset = vec2(-xaxis,yaxis)*intensity;
    vec2 gOffset = vec2(0,0)*intensity;
    vec2 bOffset = vec2(xaxis,yaxis)*intensity;

	vec4 rValue = texture2D(sampler0, xy - rOffset);
    vec4 gValue = texture2D(sampler0, xy - gOffset);
    vec4 bValue = texture2D(sampler0, xy - bOffset);

	gl_FragColor = vec4(rValue.r, gValue.g, bValue.b, 1.0);
}
