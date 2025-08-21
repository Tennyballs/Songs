// based on: https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glTexGen.xml

varying vec2 textureCoord;
varying vec4 color;
varying vec4 position;
varying vec3 normal;

uniform sampler2D sampler0;
uniform sampler2D samplerSphere;

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;

void main() {
  vec3 u = normalize( ( viewMatrix * modelMatrix * position ).xyz );
  vec3 f = reflect( u, normal );
  float m = length( f + vec3( 0.0, 0.0, 1.0 ) );
  vec2 st = 0.5 + 0.5 * f.xy / m;

  vec4 tex = texture2D( sampler0, textureCoord );
  vec4 stex = texture2D( samplerSphere, st );

  gl_FragColor = mix(
    tex * color,
    vec4( stex.xyz, tex.w ),
    stex.w
  );
}