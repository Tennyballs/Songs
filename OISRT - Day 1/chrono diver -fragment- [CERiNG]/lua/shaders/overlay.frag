#version 120

varying vec4 color;
varying vec2 imageCoord;
uniform vec2 imageSize;
uniform vec2 textureSize;
uniform sampler2D sampler0;
uniform vec3 col2;
uniform float r = 0.376470588;
uniform float g = 0.380392157;
uniform float b = 0.447058824;
uniform float opacity = 1;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }
void main()
{
    vec2 uv = imageCoord;
	vec3 col1 = texture2D( sampler0, img2tex(uv)).rgb;
	vec3 col2 = vec3(r,g,b);


	if (col1.r >= 0.5) {
		col1.r = 1 - 2 * (1 - col1.r) * (1 - col2.r);
	} else {
		col1.r = 2 * col1.r * col2.r;
	}

	if (col1.g >= 0.5) {
		col1.g = 1 - 2 * (1 - col1.g) * (1 - col2.g);
	} else {
		col1.g = 2 * col1.g * col2.g;
	}

	if (col1.b >= 0.5) {
		col1.b = 1 - 2 * (1 - col1.b) * (1 - col2.b);
	} else {
		col1.b = 2 * col1.b * col2.b;
	}

	gl_FragColor = vec4(col1, opacity) * color;
}