#version 120

varying vec2 textureCoord;
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;
uniform float textureSamplesCount = 3.0;
uniform float textureEdgeOffset = 0.005;
uniform float borderSize = 2.0;
uniform float tileSize = 24.0;
	
vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void main()
{
	vec2 tileNumber = floor(gl_FragCoord.xy / tileSize);

	vec4 accumulator = vec4(0.0);
	for (float y = 0.0; y < textureSamplesCount; ++y)
	{
		for (float x = 0.0; x < textureSamplesCount; ++x)
		{
			vec2 textureCoordinates = (tileNumber + vec2((x + 0.5)/textureSamplesCount, (y + 0.5)/textureSamplesCount)) * tileSize / imageSize.xy;
			textureCoordinates = clamp(textureCoordinates, 0.0 + textureEdgeOffset, 1.0 - textureEdgeOffset);
			accumulator += texture2D(sampler0, img2tex(textureCoordinates));
	   }
	}
	
	gl_FragColor = accumulator / vec4(textureSamplesCount * textureSamplesCount);
	vec2 pixelNumber = floor(gl_FragCoord.xy - (tileNumber * tileSize));
	pixelNumber = mod(pixelNumber + borderSize, tileSize);
	float pixelBorder = -.2 * step(min(pixelNumber.x, pixelNumber.y), borderSize) * step(borderSize * 2.0 + 1.0, tileSize);
	gl_FragColor *= pow(gl_FragColor, vec4(pixelBorder));
}