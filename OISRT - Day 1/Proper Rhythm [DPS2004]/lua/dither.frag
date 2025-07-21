#version 120
uniform float time;
varying vec4 color; // current "diffuse" value of the shadered actor
varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;

uniform sampler2D sampler0;

vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

void main() {
	vec2 coord = imageCoord.xy;
	vec2 fragCoord = imageCoord * imageSize;
	vec4 initialcolor = vec4(1,0,1,1.0);
    vec4 replacecolor = vec4(1.0,0.0,0.302,1.0);
    vec4 bgcolor = vec4(0.0,0.0,0.0,1.0);
    float tolerance = 4.0; //this will probably need to be changed when porting to notitg!!!!
    float density = 16.0;
	float movespeed = 8.0;
	vec4 c = texture2D( sampler0, img2tex(coord) );
	
    // the important code
    if(c == initialcolor){
        if(mod(fragCoord.x - time*movespeed,density) <= tolerance && mod(fragCoord.y- time*movespeed,density) <= tolerance){
            c = replacecolor;

        } else{
            c = bgcolor;
        }
    }
	
	gl_FragColor = c;
}