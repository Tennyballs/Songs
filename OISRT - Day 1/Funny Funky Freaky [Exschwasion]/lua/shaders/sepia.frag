// adapted from https://www.shadertoy.com/view/XlSyWV
#version 120

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;

uniform float innerRadius = 0.1;
uniform float outerRadius = 1.0;
uniform float opacity = 0.0;
uniform float sepiaAmount = 0.0;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / imageSize.xy;
    vec2 centered = uv - vec2(0.5);
    vec4 image = texture2D(sampler0, img2tex(uv));
    vec4 color = vec4(1.0);
    color.rgb *= 1.0 - smoothstep(innerRadius, outerRadius, length(centered));
    color *= image;
    color = mix(image, color, opacity);
	
    vec3 sepia = vec3(1.2, 1.0, 0.8);
    float grey = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 sepiaColour = vec3(grey) * sepia;
    color.rgb = mix(color.rgb, vec3(sepiaColour), sepiaAmount);
    fragColor = color;
}

void main() {
	mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}