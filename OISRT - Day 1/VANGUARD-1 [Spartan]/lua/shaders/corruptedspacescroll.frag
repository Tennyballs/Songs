// space scroll, but evil
// basically just a modified https://thebookofshaders.com/edit.php?log=161127200549
// now with an extra 4 commands!

#version 120

#ifdef GL_ES
precision mediump float;
#endif

varying vec2 imageCoord;

uniform vec2 imageSize;
uniform vec2 textureSize;
uniform float time;
uniform sampler2D sampler0;

float random (in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

#define OCTAVES 6
float fbm (in vec2 st) {
    // Initial values
    float value = -0.3;
    float amplitud = .5;
    float frequency = 0.;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitud * noise(st);
        st *= 2.;
        amplitud *= .5;
    }
    return value;
}

void main() {
    vec2 st = imageCoord;
	st.x += sin(time * 0.5);
	st.y += time;
	
	vec3 color = vec3(0.0);
	color += fbm(st*3.0);
	
	color = vec3(color.r * 0.5, 0.0, color.b);
	
	float color_sum = color.r + color.g + color.b;
    
    if (color_sum >= (0.5 - (sin(time * 4.5) * 0.1))){
        color = vec3(1.0, 1.0, 1.0);
    }  else if (color_sum >= (0.25 + (sin(time * 4.5) * 0.1))) {
        color = vec3(1.0, 0.5, 0.0);
    }	else {
        color = vec3(0.0, 0.0, 1.0);
    }

    gl_FragColor = vec4(color, 0.33);
}
