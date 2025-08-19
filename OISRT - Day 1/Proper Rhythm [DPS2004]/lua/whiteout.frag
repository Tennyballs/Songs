#version 120

varying vec4 color; // current "diffuse" value of the shadered actor
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;

uniform sampler2D sampler0;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void main() {

  vec2 coord = imageCoord.xy;
  float alpha = texture2D( sampler0, img2tex(coord) ).a;

  vec4 col = vec4(1,1,1,alpha);

  gl_FragColor = col;
}