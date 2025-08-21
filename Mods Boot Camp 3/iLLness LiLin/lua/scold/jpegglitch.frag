uniform	float segments; // How many segments image is split into
uniform	float colorSegments; // how many different color effects are added
uniform	float segmentsBegin; // Segment beginning point from top, 0 - 1
uniform	float noSegment; // Chance of no segment appearing, 0 - 1
uniform	float maxShift; // Maximum x shifting of the segments
uniform	float seed; // seed for randomizer
uniform float coloring; // multiplier of coloring effect, 0 = none, can be above 1

uniform sampler2D sampler0;

varying vec2 textureCoord;
varying vec2 imageCoord;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(){
	vec4 color = texture2D(sampler0, textureCoord.xy);

	if (imageCoord.y <= (1.0 - segmentsBegin))
	{
		float segmentSize = (1.0 - segmentsBegin) / segments;
		float curSegment = floor(textureCoord.y / segmentSize + 0.5) * segmentSize;
		curSegment = curSegment + sin(curSegment * 20.0);
		float random = rand(vec2(seed, curSegment));

		if (random > noSegment)
		{
			vec2 coord = vec2(textureCoord.x + clamp(random * 2.0 - 1.0, -maxShift, maxShift), textureCoord.y);
			if (coord.x > 1.0) coord.x -= floor(coord.x);
			else if (coord.x < 0.0) coord.x = 1.0 - abs(coord.x);
			color = texture2D(sampler0, coord);

			float colorSegmentSize = (1.0 - segmentsBegin) / colorSegments;
			float curColorSegmentX = floor(textureCoord.x * 5.0 + 0.5) / 5.0;
			float curColorSegmentY = floor(textureCoord.y * (colorSegmentSize * 3.0) + 0.5) / (colorSegmentSize * 3.0);

			float curColorSegment = floor(textureCoord.y + (rand(vec2(seed, curColorSegmentX + curColorSegmentY))) * 0.5 / colorSegmentSize + 0.5) * colorSegmentSize;
			float colorRandom = rand(vec2(seed, curColorSegment));

			if(rand(vec2(seed, curColorSegmentX + curColorSegmentY)) > 0.05){
				// Coloring options, edit how ever you want
				if(colorRandom < 0.2) color.x -= colorRandom * 5.0 * coloring;
				else if(colorRandom >= 0.1 && colorRandom < 0.2) color.yz *= colorRandom * 2.5 * coloring;
				else if(colorRandom >= 0.2 && colorRandom < 0.3) color.xy -= colorRandom * 2.5 * coloring;
				else if(colorRandom >= 0.3 && colorRandom < 0.4) color.xz /= colorRandom * 1.25 * coloring;
				else if(colorRandom >= 0.4 && colorRandom < 0.5) color.yz -= colorRandom * 1.25 * coloring;
				else if(colorRandom >= 0.5 && colorRandom < 0.6) color.xy += colorRandom * 0.625 * coloring;
				else if(colorRandom >= 0.6 && colorRandom < 0.7) color.xy -= colorRandom * 0.625 * coloring;
				else if(colorRandom >= 0.7 && colorRandom < 0.8) color.xz -= colorRandom * coloring;
				else if(colorRandom >= 0.8 && colorRandom < 0.9) color.yz -= colorRandom * coloring;
				else if(colorRandom >= 0.9) color.xyz += colorRandom * coloring;
			}
		}
	}

	// Random glitch squares
	float curColorSegmentX = floor(textureCoord.x * 100.0 + 0.5) / 100.0;
	float curColorSegmentY = floor(textureCoord.y * 100.0 + 0.5) / 100.0;
	float colorRandom = rand(vec2(seed, curColorSegmentX  * curColorSegmentY));

	if(colorRandom > 0.09 && colorRandom < 0.1) color.xyz -= 0.03;
	else if(colorRandom >= 0.29 && colorRandom < 0.3) color.xyz *= 0.95;
	else if(colorRandom >= 0.499 && colorRandom < 0.5) color.xyz = 1.0 - color.xyz;
	else if(colorRandom >= 0.69 && colorRandom < 0.7) color.xyz *= 1.05;
	else if(colorRandom >= 0.899 && colorRandom < 0.9) color.xyz += color.xyz;

	gl_FragColor = color;
}