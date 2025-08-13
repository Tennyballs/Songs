#version 120

uniform float amount; // strength of pixelation

varying vec2 imageCoord;
uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }


void main() {
    vec2 uv = imageCoord;
    uv = floor(uv * textureSize / amount) * amount / textureSize;

    gl_FragColor = texture2D(sampler0, img2tex(uv));
}