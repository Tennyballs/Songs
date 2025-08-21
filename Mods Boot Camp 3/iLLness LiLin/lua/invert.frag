#define PI 3.14159265

varying vec4 color;
varying vec2 textureCoord;
uniform sampler2D sampler0;

uniform float ohno;
uniform float ohnoo;
uniform float ohnooo;

void main() {

  vec4 col = vec4(1.0) - texture2D( sampler0, textureCoord )*color;
  col = col -  vec4(sin(textureCoord.x*textureCoord.y*ohno),sin(textureCoord.x*textureCoord.x*ohnoo),sin(textureCoord.y*textureCoord.y*ohnooo),0);
  gl_FragColor = vec4(col.xyz , color.w);
}