// taken from FMS_Cat's Analys
// go check him out!!!!! https://www.youtube.com/watch?v=eqZE60HanCM

#version 120

#define PI 3.14159265
#define SAMPLES 20
#define saturate(i) clamp(i,0.,1.)

// ------

varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform float beat;

uniform bool isVert;
uniform float var = 1.0;

uniform sampler2D sampler0;

// ------

float gaussian( float _x, float _v ) {
  return 1.0 / sqrt( 2.0 * PI * _v ) * exp( - _x * _x / 2.0 / _v );
}

// ------

bool isValidUV( vec2 v ) { return 0.0 < v.x && v.x < 1.0 && 0.0 < v.y && v.y < 1.0; }
vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void main() {
  
  vec2 uv = imageCoord;
  vec2 bv = ( isVert ? vec2( 0.0, 1.0 ) : vec2( 1.0, 0.0 ) ) / imageSize;

  vec3 sum = vec3( 0.0 );
  for ( int i = -SAMPLES; i <= SAMPLES; i ++ ) {
    vec2 v = saturate( uv + bv * float( i * 2 ) );
    vec3 tex = texture2D( sampler0, img2tex( v ) ).xyz;
    float mul = saturate( gaussian( abs( float( i ) ), var ) );
    sum += tex * mul;
	
	if (beat > 613.0 && beat < 678.0){
	float grayamt = cos((beat - 613.0)/2.0) * 0.04 + 0.96 ;
	sum = sum * grayamt + vec3(.299*sum.x + .587*sum.y + .114*sum.z) * (1.0 - grayamt);
	}
  }

  gl_FragColor = vec4( sum, 1.0 );
}