#version 120

#define PI 3.14159265

attribute vec4 TextureMatrixScale;

varying vec3 normal;
varying vec4 color;

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform sampler2D samplerRandom;

uniform vec2 textureSize;
uniform vec2 imageSize;

uniform float amp;

void main() {
  normal = gl_NormalMatrix * gl_Normal * vec3( 1.0, -1.0, 1.0 );
  
  vec3 sphere = vec3(
    cos( gl_Vertex.y / 240.0 * PI / 2.0 ) * sin( gl_Vertex.x / 320.0 * PI / 2.0 ),
    sin( gl_Vertex.y / 240.0 * PI / 2.0 ),
    cos( gl_Vertex.y / 240.0 * PI / 2.0 ) * cos( gl_Vertex.x / 320.0 * PI / 2.0 )
  );
  vec3 rnd = texture2D(
    samplerRandom,
    mod( gl_Vertex.xy * 0.001 - 0.5, 1.0 )
  ).xyz - 0.5;

  vec3 vert = mix(
    gl_Vertex.xyz,
    60.0 * sphere + 60.0 * rnd,
    amp
  );
  gl_Position = gl_ModelViewProjectionMatrix * vec4( vert, 1.0 );
  
  gl_TexCoord[ 0 ] = gl_TextureMatrix[ 0 ] * gl_MultiTexCoord0;
  textureCoord = gl_TexCoord[ 0 ].xy;
  imageCoord = textureCoord * textureSize / imageSize;
  
  gl_FrontColor = gl_Color;
  color = gl_Color;
}


    // vec3(
    //   100.0 * sin( gl_Vertex.x / 320.0 * PI ),
    //   gl_Vertex.y,
    //   -100.0 * cos( gl_Vertex.x / 320.0 * PI )
    // ),