#version 120
uniform float amount;

varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;


void main()
{
    float pixelization = 1.0 / amount;
    float ratio = imageSize.y / imageSize.x;
    float v = (floor(imageCoord.y * amount) * pixelization + pixelization * 0.5) / textureSize.y * imageSize.y;
    pixelization = ratio / amount;
    float u = (floor(imageCoord.x / pixelization) * pixelization + pixelization * 0.5) / textureSize.x * imageSize.x;
    gl_FragColor = texture2D( sampler0, vec2(u, v) );
}
