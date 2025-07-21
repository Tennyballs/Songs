#version 120
// shader source https://www.shadertoy.com/view/7dS3z3
uniform float time;
uniform vec2 resolution;
uniform vec2 imageSize;
uniform vec2 textureSize;
varying vec2 textureCoord;
varying vec2 imageCoord;
uniform sampler2D sampler0;
vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }
//replace fragcoord with (imageCoord * imageSize)

uniform float speed = 5;
uniform float frequency = 10.0;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{

    float t = time * speed;
    vec2 position = ((imageCoord * imageSize).xy - imageSize.xy * .5) / imageSize.x;
   
    float angle = atan(position.y, position.x) / (2. * 3.14159265359);
    angle -= floor(angle);
    float rad = length(position);
    float angleFract = fract(angle * 256.);
    float angleRnd = floor(angle * 100.) + 1.;
    float angleRnd1 = fract(angleRnd * fract(angleRnd * .7235) * 45.1);
    float angleRnd2 = fract(angleRnd * fract(angleRnd * .82657) * 13.724);
    float t2 = t + angleRnd1 * frequency;
    float radDist = sqrt(angleRnd2);
    float adist = radDist / rad * .1;
     float dist = (t2 * .1 + adist);
    dist = abs(fract(dist) - 0.5);
    
    float outputColor = (1.0 / (dist)) * cos(0.7 ) * adist / radDist / 30.0;
    angle = fract(angle + .61);
    
    vec2 uv = (imageCoord * imageSize)/imageSize.xy;
    vec3 col = 0.5 + 0.5*cos(time+uv.xyx+vec3(0,2,4));

    fragColor = vec4(outputColor * col,1.0);
}

void main()
{
	mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}