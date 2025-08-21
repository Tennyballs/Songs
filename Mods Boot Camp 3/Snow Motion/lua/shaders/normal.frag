uniform sampler2D sampler0;
varying vec2 textureCoord;
varying vec4 color;
varying vec3 normal;
void main (void)
{
  vec4 tex = texture2D( sampler0, textureCoord );
  gl_FragColor = vec4( 0.5 + 0.5 * normal, tex.w );
}