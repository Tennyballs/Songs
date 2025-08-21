#version 130
#define PI 3.14159265

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
uniform sampler2D bayer;

uniform float bayerResolution = 8.0;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

// https://www.shadertoy.com/view/4tSBDK

#define COLORS_PER_CHANNEL 1.0
#define R (1.0 / COLORS_PER_CHANNEL)

vec3 palettize(vec3 color) {
    vec3 newColor;
    modf(color.r * COLORS_PER_CHANNEL, newColor.r);
    modf(color.g * COLORS_PER_CHANNEL, newColor.g);
    modf(color.b * COLORS_PER_CHANNEL, newColor.b);
    return newColor / COLORS_PER_CHANNEL;
}

float dithering(vec2 uv) {
    vec2 tex;
    tex.x = mod(uv.x, bayerResolution);
    tex.y = mod(uv.y, bayerResolution);
    tex = tex / bayerResolution;
    return R * float(texture2D(bayer, img2tex(tex))) ;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / imageSize.xy;
    vec3 color = texture2D(sampler0, img2tex(uv)).rgb + dithering(fragCoord.xy);
    //vec3 color = vec3(uv.x, uv.y, 0.5 + 0.5*sin(iTime))  + dithering(fragCoord.xy);
    fragColor = vec4(palettize(color),1.0);
}

void main()
{
	mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}
