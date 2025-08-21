#version 120

#define BG_Z -1000.0
#define FOVY 60.0

#define PI 3.14159265

varying vec2 textureCoord;
varying vec4 color;
varying vec3 position;
varying vec3 normal;

uniform sampler2D sampler0;
uniform sampler2D samplerSphere;
uniform sampler2D samplerDry;
uniform vec2 samplerDryTextureSize;
uniform vec2 samplerDryImageSize;

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform vec2 resolution;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform float beat;

// ------

vec2 img2texDry( vec2 v ) { return v * samplerDryImageSize / samplerDryTextureSize; }

// ------

void main() {
  vec4 diffuse = texture2D( sampler0, textureCoord );

  vec3 n = normal;
  vec2 uv = gl_FragCoord.xy / resolution;

  vec2 bgSize = (
    vec2( samplerDryImageSize.x / samplerDryImageSize.y, 1.0 ) *
    abs( BG_Z ) / cos( FOVY / 180.0 * PI ) * sin( FOVY / 180.0 * PI ) * 2.0
  );

  vec3 ro = vec3( 0.0 );
  vec3 rd = normalize( ( viewMatrix * modelMatrix * vec4(position.xyz,1) ).xyz );
  if ( 0.0 < dot( rd, n ) ) { n = -n; }
  vec3 c0 = ro + ( BG_Z - ro.z ) / rd.z * rd;

  vec3 col = vec3( 0.0 );
  for ( int i = 0; i < 3; i ++ ) {
    vec3 ro2 = ( viewMatrix * modelMatrix * vec4(position.xyz,1) ).xyz;
    float eta = mix( 1.0, 0.7 - 0.02 * float( i ), 1.0 );
    vec3 rd2 = refract( rd, n, eta );
    vec3 c1 = ro2 + ( BG_Z - ro2.z ) / rd2.z * rd2;
    vec2 d = ( c1 - c0 ).xy / bgSize;
    col[ i ] = texture2D( samplerDry, img2texDry( fract( uv + d ) ) )[ i ];
  }
  
  vec3 ref = reflect( rd, n );
  
  float m = length( ref + vec3( 0.0, 0.0, 1.0 ) );
  vec2 st = 0.5 + 0.5 * ref.xy / m;
  vec4 reftex = texture2D( samplerSphere, st );
  col += pow( reftex.xyz * reftex.w, vec3( 2.0 ) ) * 1.0;

  gl_FragColor = vec4( col, diffuse.w );
}