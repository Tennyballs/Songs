uniform sampler2D sampler0;
varying vec2 textureCoord;

void main (void)
{
  gl_FragColor = texture2D( sampler0, textureCoord );
}