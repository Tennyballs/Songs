//violent rain shader by Kuut! :D http://blog.kuut.xyz/

#version 120

#define PI 3.14159265359

uniform vec2 resolution;

uniform float beat = 0;
uniform float time = 0;
varying vec2 textureCoord;
varying vec2 imageCoord;
varying vec4 color;

uniform float much = 1;

uniform vec2 textureSize;
uniform vec2 imageSize;

uniform sampler2D sampler0;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

void main( void )
{
    float speed = 0.05;
    float amount = 0.45*much;
    float amount2 = 0.2*much;
    float size = 3.0;
	
	float iTime = beat/3;
    
    //vec2 uv = gl_FragCoord.xy/resolution.xy;
    vec2 uv = imageCoord;
    
	vec2 normalUv = uv;
    // Make drops flow in wavy patterns
    float warp = sin((uv.y + uv.x + fract(iTime * 0.01)) * 25.0);
    warp = clamp(warp * 2.0, -1.0, 1.0);
    uv.x += warp * 0.005;
    // Makes drops flow different speeds at certain points
    uv.y += (0.5 + sin((uv.y - uv.x * 0.25) * 20.0) * 0.5) * 0.1;
	
    uv /= size;
	
    float col = 0.0;
    
    float col2 = texture2D(sampler1, vec2(uv.x * 2.0, uv.y / 30.0 + fract(iTime * 0.025 * speed))).x;
    col += (1.0 - smoothstep(col2, -0.02 * amount2, 0.02 * amount2));
    
    col2 = texture2D(sampler1, vec2(uv.x * 1.0, uv.y / 60.0 + fract(iTime * 0.025 * speed))).x;
    col += pow(1.0 - smoothstep(col2, -0.05 * amount, 0.05 * amount), 1.5);
    gl_FragColor = vec4(col, col, col, 1.0);

    col *= 0.05;
    vec2 coord = clamp(normalUv, 0.0, 1.0);
    
	float fin = col;
	
    // droplets
    float drop = texture2D(sampler2, normalUv * 4.0 * sin(normalUv.x + normalUv.y) + iTime * 0.1).x;
    drop -= 0.79 + sin(uv.y * 100.0 + iTime * 16.0 * amount) * cos(uv.x * 100.0) * 0.25;
    drop = pow(drop, 5.0) * 2.0;
    
    fin = max(col, drop);
    if (drop * 0.25 > col) fin = drop;
    
    coord += fin;
    
    gl_FragColor = texture2D(sampler0, texCoord2imgCoord(vec2(clamp(coord.x,0,1),clamp(coord.y,0,1))) )*color;

    fin *= 10.0;
    //fragColor = vec4(fin, fin, fin, 1.0);
    //fragColor = texture2D(sampler0, uv);
}