#version 120
#define PI 3.14159265

varying vec3 position;
varying vec3 normal;
varying vec4 color;
varying vec2 textureCoord;
varying vec2 imageCoord;

uniform float time;
uniform float beat;
uniform vec2 resolution;
uniform vec2 textureSize;
uniform vec2 imageSize;
uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 perspectiveMatrix;
uniform mat4 textureMatrix;
uniform sampler2D sampler0;
uniform sampler2D sampler1;

uniform float amount;


//replacing fragCoord with imageCoord * imageSize, and resolution with imageSize will make it work perfectly! -FMS_Cat
vec2 img2tex( vec2 v ) { return v / textureSize * imageSize; }

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (imageCoord * imageSize).xy / imageSize.xy;
    
    vec3 hsv = rgb2hsv(texture2D(sampler0, img2tex(uv)).rgb);
    
    float angle = hsv.x + atan(uv.y, uv.x) + time*0.1;
    mat2 RotationMatrix = mat2( cos( angle ), -sin( angle ), sin( angle ),  cos( angle ));
    vec3 col = texture2D(sampler0, img2tex(uv) + RotationMatrix * vec2(log(max(amount, 0.)*0.2 + 1.  ) * 0.1,0) * hsv.y).rgb;
    
    fragColor = vec4(col,1.0)*color;
}

void main()
{
	mainImage(gl_FragColor.rgba, gl_FragCoord.xy);
}
