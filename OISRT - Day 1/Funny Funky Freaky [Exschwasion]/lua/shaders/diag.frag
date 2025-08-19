#version 120

uniform float dist = 4.2;

varying vec2 imageCoord;

uniform vec2 textureSize;
uniform vec2 imageSize;
uniform sampler2D sampler0;

void main()
{

    vec2 uv = imageCoord / textureSize * imageSize;
    float aspect = textureSize.x/textureSize.y;
    float diag = (uv.x*aspect+uv.y)*100.;
    vec4 col = vec4(0.);
	if (mod(diag,4.) > dist){
        col = texture2D(sampler0, uv);
    }
    gl_FragColor = col;
}
