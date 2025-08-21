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
		
		
		//tex.x -= sin(tex.y*4.0)*.05;

		tex.x -= exp(-sin(-.5+tex.y*4.0))*clamp(tex.x-.5,-1,1)*2.0;
		tex.y -= exp(-sin(.2+tex.x*4.0))*clamp(tex.y-.5,-1,1)*0.2;
		//tex.y -= log(sin(-.5+tex.x*4.0))*clamp(tex.y-.5,-1,1)*.2;

		
		ydist = tex.y;
		xdist = tex.x;
		vec3 col = texture2D(sampler0,texCoord2imgCoord(vec2(xdist,ydist)));
		float lumi = gray( col );
		
	
	float y = tex.y;
	float x = tex.x;
	

		gl_FragColor = vec4(texture2D(sampler0,texCoord2imgCoord(vec2(xdist,ydist))));
		
		//gl_FragColor = vec4( col, smoothstep( 0.0, 0.4, lumi ) );

}