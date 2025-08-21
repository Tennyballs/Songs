#version 120

uniform float timer;
uniform float left = 0;
uniform float right = 0;
uniform float top = 0;
uniform float bottom = 0;

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;

varying vec4 color;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

uniform sampler2D sampler0;

//float3 UVClampPass( float4 vpos : SV_Position, float2 texcoord : TexCoord ) : SV_Target {
void main (void)
{
	vec2 uv = imageCoord;

	float amp = 0.5;

	uv.x = clamp( uv.x, left, 1.0 - right );
	uv.y = clamp( uv.y, top, 1.0 - bottom );

	gl_FragColor = texture2D( sampler0, texCoord2imgCoord(uv) )*color;
}