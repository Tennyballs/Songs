#version 120

varying vec2 textureCoord;
uniform sampler2D sampler0;

uniform vec4 scheme[16];

void main() {
	vec4 target = texture2D(sampler0, textureCoord);
	vec4 result = vec4(0.);
	float d = 10.;
	for (int i = 0; i < 16; i++) {
		vec4 s = scheme[i];
		float d2 = distance(target, s);
		if (d2 < d) {
			d = d2;
			result = s;
		}
	}
	gl_FragColor = result;
}
