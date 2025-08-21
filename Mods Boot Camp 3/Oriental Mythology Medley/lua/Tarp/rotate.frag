#version 120

#define PI 3.14159265
#define saturate(i) clamp(i,0.,1.)

varying vec2 textureCoord;
varying vec2 imageCoord;
varying vec4 color;

uniform vec2 textureSize;
uniform vec2 imageSize;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

uniform float amp = 0;

uniform sampler2D sampler0;

mat2 rotate2D( float r )
{
  return mat2( cos( r ), sin( r ), -sin( r ), cos( r ) );
}

void main()
{

  float ang = amp;
  
  vec2 uvn = rotate2D( ang ) * ( (textureCoord) - vec2( 0.5*(imageSize / textureSize) ) ) + vec2( 0.5*(imageSize / textureSize) );
  uvn *= (textureSize / imageSize);
  vec3 inputDistort = texture2D( sampler0, texCoord2imgCoord( uvn ) ).xyz;

  gl_FragColor = vec4( saturate( inputDistort ), 1.0 )*color;
  
}