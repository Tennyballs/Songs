// https://www.shadertoy.com/view/4ss3WX

#version 120

const float PI = 3.141592658;
const float TAU = 2.0 * PI;
const float sections = 8.0;

uniform sampler2D sampler0;

uniform float time = 0;

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;

varying vec4 color;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

void main( ){
  vec2 pos = vec2((imageCoord * imageSize).xy - 0.5 * imageSize.xy) / imageSize.y;

  float rad = length(pos);
  float angle = atan(pos.y, pos.x) + time/3.0;

  float ma = mod(angle, TAU/sections);
  ma = abs(ma - PI/sections);
  
  float x = cos(ma) * rad;
  float y = sin(ma) * rad;
	
  gl_FragColor = texture2D(sampler0, texCoord2imgCoord(vec2(x+0.03-0.02*sin(time*2), y+0.03-0.02*sin(time*2))) )*color;
  //gl_FragColor = texture2D(sampler0, texCoord2imgCoord(textureCoord) );
}

float Tile1D(float p, float a){
  p -= 4.0 * a * floor(p/4.0 * a);
  p -= 2.* max(p - 2.0 * a , 0.0);
  return p;
}

//replacing fragCoord with imageCoord * imageSize, and resolution with imageSize will make it work perfectly!