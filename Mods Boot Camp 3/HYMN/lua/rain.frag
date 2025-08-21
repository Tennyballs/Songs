#version 120

#define PI 3.14159265359

uniform vec2 resolution;

uniform float beat = 0;
uniform float drops = 32;
uniform float rainAlpha = 0.6;
uniform float rainSize = 0.01;
uniform float rainAngle = PI/18.0;
uniform float rainSpeed = 1;

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

uniform sampler2D sampler0;

float Dist( vec2 p1, vec2 p2 )
{
	return sqrt( ((p2.x-p1.x)*(p2.x-p1.x)*(imageSize.x/imageSize.y)*(imageSize.x/imageSize.y)) + (p2.y-p1.y)*(p2.y-p1.y) );
}

const float radius=2.;
const float depth=radius/2.;

float SawTooth(float t) {
    return 0.5*cos(t+cos(t))+sin(2.*t)*.2+sin(4.*t)*.01;
}

float DeltaSawTooth(float t) {
    return 0.6*cos(2.*t)+0.08*cos(4.*t) - (1.-sin(t))*sin(t+cos(t));
}

float rand(vec2 n) {
    return fract(sin(cos(dot(n, vec2(12.9898,12.1414)))) * 83758.5453);
}

void main (void)
{

	float f = 0;
	vec2 uv = imageCoord.xy;
	vec2 magnifierArea;
	
	vec2 dropPos;
	float dropSize;
	float depth;
	vec2 center;
	float ax;
	float dx;
	
	float randt;
	float randt2;
	
	gl_FragColor = vec4(texture2D( sampler0, texCoord2imgCoord(uv)).rgb, 1.);
	
	for( float i=0.0; i<drops; i++ ){
	
		randt = beat + PI*rand( vec2(i+64.0,i+96.0) );
		randt2 = floor(randt/2.0);
		
		dropPos = vec2( mod(rand(vec2(i+randt2, i+32.0)) + rainSpeed*randt*-30.0/480.0*sin(rainAngle) ,1.1) - 0.05 , mod( rand(vec2(i+32.0 + randt2, i+64.0)) + rainSpeed*randt*-30.0/480.0*cos(rainAngle) - 0.5 ,1.1) - 0.05 );
		dropSize = (0.0 + rainSize*rand(vec2(i, i+32.0)))* max(1-1.5*(randt/2.0 - floor(randt/2.0)), 0);
		depth=dropSize/2.0;
		
		center = dropPos.xy;
		ax = ((uv.x - center.x) * (uv.x - center.x)) / (0.06 - 0.03*sin(PI*randt/2.0)) + ((uv.y - center.y) * (uv.y - center.y)) / (0.1/ ( resolution.x / resolution.y )) ;
		dx = 0.0 + (-depth/dropSize)*ax + (depth/(dropSize*dropSize))*ax*ax;
		
		if( ax < dropSize ){
			f = -10*(ax + dx);
			magnifierArea = center + (uv-center)*f/ax;
			gl_FragColor = mix(vec4(texture2D( sampler0, texCoord2imgCoord(uv)).rgb, 1.),vec4(texture2D( sampler0, texCoord2imgCoord(magnifierArea)).rgb, 1.),rainAlpha);
		}
		
	}
	
}