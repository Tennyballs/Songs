#version 120

varying vec2 textureCoord;
varying vec4 color;
varying vec2 imageCoord;
uniform float yOffset;

uniform float zPos;
uniform float time;
uniform float burn = 0;
uniform vec2 textureSize;
uniform vec2 imageSize;
uniform vec2 resolution;

#define img2tex(v) ( v / textureSize * imageSize )

uniform sampler2D sampler0;

// --------------------------------------------------------
//  "Burning Texture Fade" by Krzysztof Kondrak @k_kondrak
// --------------------------------------------------------

float r(vec2 n)
{
    return fract(cos(dot(n,vec2(36.26,73.12)))*354.63);
}
float noise(vec2 n)
{
    vec2 fn = floor(n);
    vec2 sn = smoothstep(vec2(0),vec2(1),fract(n));
    
    float h1 = mix(r(fn),r(fn+vec2(1,0)),sn.x);
    float h2 = mix(r(fn+vec2(0,1)),r(fn+vec2(1)),sn.x);
    return mix(h1,h2,sn.y);
}
float value(vec2 n)
{
    float total;
    total = noise(n/32.)*0.5875+noise(n/16.)*0.2+noise(n/8.)*0.1
            +noise(n/4.)*0.05+noise(n/2.)*0.025+noise(n)*0.0125;
 	return total;
}



// PRNG
// From https://www.shadertoy.com/view/4djSRW
float prng(in vec2 seed) {
	seed = fract (seed * vec2 (5.3983, 5.4427));
	seed += dot (seed.yx, seed.xy + vec2 (21.5351, 14.3137));
	return fract (seed.x * seed.y * 95.4337);
}


void main()
{
    vec2 uv = gl_FragCoord.xy / imageSize;
	//uv.y = 1.0-uv.y;
    //float t = (time-1.0)*.15;
    float t = burn;
	
	if( burn > 0 ){
		// fade to black
		vec4 c = mix(texture2D(sampler0, img2tex(imageCoord)), vec4(0), smoothstep(t + .1, t - .1, value(gl_FragCoord.xy * .25)));
		
		// burning on the edges (when c.a < .1)
		c.rgb = clamp(c.rgb + step(c.a, 0.6) * 1.6 * value(2.0*gl_FragCoord.xy) * vec3(1.4,.5,.0), 0., 1.);
		
		// plain burn-to-black
		c.rgb = c.rgb * step(.01, c.a);
		
		gl_FragColor = c*color;
	}else{
		gl_FragColor = texture2D(sampler0, img2tex(imageCoord));
	}
}