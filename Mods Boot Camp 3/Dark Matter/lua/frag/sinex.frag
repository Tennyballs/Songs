#version 120

uniform float timer;
uniform float amp;
uniform float wave;
uniform float speed;
uniform float period;
uniform float lmult;
uniform float rmult;

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

float gray( vec3 c ) {
  return 0.299 * c.x + 0.587 * c.y + 0.114 * c.z;
}

uniform sampler2D sampler0;

//float3 LensSinePass(float2 tex, int wave, int var, float intensity, float yspacing, float speed, float windup)
void main (void)
{
	float mult = amp;
	vec2 tex = imageCoord;

	// get the right pixel for the current position
	float xdist = 0;
	float ydist = 0;
	float yspacing = period;
	
		//tex.y += log(tex.x);
		//tex.y -= exp((tex.x*100)*0.1)*-0.01;
		
		float res = (imageSize.x/imageSize.y)/1.333;
		float surplus = res-1.0;
		
		if(tex.x>.5){
		tex.y -= clamp(tan((tex.x*4)+0.1 + .8*surplus)*rmult,0,1)*clamp(tex.y-.5,-1,1);
		};
		if(tex.x<.5){
		tex.y -= clamp(tan((-tex.x*4)-2.1 + .6*surplus)*lmult,0,1)*clamp(tex.y-.5,-1,1);
		};
		
		if(tex.y<.6){
		tex.x -= clamp(tan((-tex.y*4)+1.1)*0,0,1)*clamp(tex.x-.5,-1,1);
		};
		
		ydist = tex.y;
		xdist = tex.x;
		vec3 col = texture2D(sampler0,texCoord2imgCoord(vec2(xdist,ydist))).xyz;
		float lumi = gray( col );
		
	
	float y = tex.y;
	float x = tex.x;
	

		gl_FragColor = vec4(texture2D(sampler0,texCoord2imgCoord(vec2(xdist,ydist))));
		
		//gl_FragColor = vec4( col, smoothstep( 0.0, 0.4, lumi ) );

}