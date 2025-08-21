#version 120
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

//replacing fragCoord with imageCoord * imageSize, and resolution with imageSize will make it work perfectly! -FMS_Cat
//credit: https://www.shadertoy.com/view/MltBzf
vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

float rand(vec2 p)
{
    float t = floor(time * 45.) / 10.;
    return fract(sin(dot(p, vec2(t * 12.9898, t * 78.233))) * 43758.5453);
}

float noise(vec2 uv, float blockiness)
{   
    vec2 lv = fract(uv);
    vec2 id = floor(uv);
    
    float n1 = rand(id);
    float n2 = rand(id+vec2(1,0));
    float n3 = rand(id+vec2(0,1));
    float n4 = rand(id+vec2(1,1));
    
    vec2 u = smoothstep(0.0, 1.0 + blockiness, lv);

    return mix(mix(n1, n2, u.x), mix(n3, n4, u.x), u.y);
}

float fbm(vec2 uv, int count, float blockiness, float complexity)
{
    float val = 0.0;
    float amp = 0.5;
    
    while(count != 0)
    {
    	val += amp * noise(uv, blockiness);
        amp *= 0.5;
        uv *= complexity;    
        count--;
    }
    
    return val;
}

uniform float glitchAmplitude = 0.1;
uniform float glitchNarrowness = 1500.0;
uniform float glitchBlockiness = 2.0;
uniform float glitchMinimizer = 4.0;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (imageCoord * imageSize)/imageSize.xy;
    vec2 a = vec2(uv.x * (imageSize.x / imageSize.y), uv.y);
    vec2 uv2 = vec2(a.x / imageSize.x, exp(a.y));
	vec2 id = floor(uv * 8.0);
    //id.x /= floor(texture(iChannel0, vec2(id / 8.0)).r * 8.0);

    // Generate shift amplitude
    float shift = glitchAmplitude * pow(fbm(uv2, int(rand(id) * 6.), glitchBlockiness, glitchNarrowness), glitchMinimizer);
    
    // Create a scanline effect
    float scanline = abs(cos(uv.y * 400.));
    scanline = smoothstep(0.0, 2.0, scanline);
    shift = smoothstep(0.00001, 0.2, shift);
    
    // Apply glitch and RGB shift
    float colR = texture2D(sampler0, img2tex(vec2(uv.x + shift, uv.y))).r * (1. - shift) ;
    float colG = texture2D(sampler0, img2tex(vec2(uv.x - shift, uv.y))).g * (1. - shift) + rand(id) * shift;
    float colB = texture2D(sampler0, img2tex(vec2(uv.x - shift, uv.y))).b * (1. - shift);
    // Mix with the scanline effect
    vec3 f = vec3(colR, colG, colB) - (0.1 * scanline);
    
    // Output to screen
    fragColor = vec4(f, 1.0)*color;
}

void main()
{
	mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}
