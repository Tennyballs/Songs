attribute vec4 TextureMatrixScale;

varying vec3 position;
varying vec3 normal;
varying vec4 color;

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform bool isHold;

uniform vec2 textureSize;
uniform vec2 imageSize;

void main() {
  normal = gl_Normal * vec3( 1.0, -1.0, 1.0 );
  if ( isHold ) { normal = vec3( 0.0, 0.0, 1.0 ); }
  normal = gl_NormalMatrix * normal;
  if ( isHold && dot( normal, vec3( 0.0, 0.0, 1.0 ) ) < 0.0 ) {
    normal = -normal;
  }

  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  position = gl_Vertex.xyz;
  
  gl_TexCoord[0] = (gl_TextureMatrix[0] * gl_MultiTexCoord0 * TextureMatrixScale) + (gl_MultiTexCoord0 * (vec4(1)-TextureMatrixScale));
  textureCoord = ((gl_TextureMatrix[0] * gl_MultiTexCoord0 * TextureMatrixScale) + (gl_MultiTexCoord0 * (vec4(1)-TextureMatrixScale))).xy;
  imageCoord = textureCoord * textureSize / imageSize;
  
  gl_FrontColor = gl_Color;
  color = gl_Color;
}