#version 120

varying vec2 textureCoord;
varying vec2 imageCoord;


uniform float loopsx;
uniform float loopsy;
uniform float scrollx;
uniform float scrolly;
uniform float time;
uniform float libsi;
uniform float tansize;
uniform float sinmult;
uniform vec2 textureSize;
uniform vec2 imageSize;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

uniform sampler2D sampler0;
/*
//float3 LensSinePass(float2 tex, int wave, int var, float intensity, float yspacing, float speed, float windup)
void main (void)
{
	vec2 tex = imageCoord;

		
	
	float y = tex.y;
	float x = tex.x;
	

		gl_FragColor = vec4(texture2D(sampler0,texCoord2imgCoord(vec2(x*2,y))));
		

} */

float gray( vec3 c ) {
  return 0.299 * c.x + 0.587 * c.y + 0.114 * c.z;
}

void main() {
	float stx = textureCoord.x;
	float sty = textureCoord.y;
	
	stx = ((imageCoord.x*loopsx)-loopsx/2)+.5+scrollx-tan(imageCoord.y*loopsy*8.3)*tansize-sin(20*time+imageCoord.y*500)*sinmult;
	stx = fract(stx);
	sty = ((imageCoord.y*loopsy)-loopsy/2)+.5+scrolly;	
	sty = fract(sty);
	
	//sty = fract(imageCoord*1);
    vec3 color = texture2D(sampler0,texCoord2imgCoord(vec2(stx,sty))).xyz;

	float lumi = gray( color );

	gl_FragColor = vec4( color, smoothstep( 0.0, 0.4, lumi*libsi ) );
}