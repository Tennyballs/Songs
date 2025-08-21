/// This shader was grabbed from http://glslsandbox.com/ and modified a bit for the purposes of the Celestial Harbor SRT

const float PI=3.14159265358979323846;
varying vec2 textureCoord;
uniform float time;

#define speed (time*1)
#define ground_x (1.0-0.325*sin(PI*speed*0.25))
float ground_y=1.0;
float ground_z=0.5;

vec2 rotate(vec2 k,float t)
	{
	return vec2(cos(t)*k.x-sin(t)*k.y,sin(t)*k.x+cos(t)*k.y);
	}

float draw_scene(vec3 p)
	{

	float tunnel1=length(mod(p.xy,2.0)-1.0)-0.45;	// tunnel1
	float tunnel2=length(mod(p.xy,2.0)-1.0)-(0.425+0.025*cos(PI*p.y*8.0)+0.025*cos(PI*p.z*8.0)); // tunnel2
	float hole1=length(mod(p.xz,1.0).xy-0.5)-0.5;	// hole1
	float hole2=length(mod(p.yz,0.25).xy-0.125)-0.09375;	// hole2
	float hole3=length(mod(p.xy,0.25).xy-0.125)-(0.0625+0.125*sin(PI*p.z*2.0));	// hole3
	float tube_p=0.5+0.075*sin(PI*p.z*1.0);
	float tube=length(mod(p.xy,tube_p)-tube_p*0.5)-(tube_p*0.025+0.00125*cos(PI*p.z*128.0)); // tube
	float bubble_p=0.05;
	float bubble=length(mod(p.yz,.05)-.025)-(.025+0.025*cos(PI*p.z*2.0));	// bubble
	return max(min(min(-tunnel1,mix(tunnel2,-bubble,0.375)),max(min(-hole1,hole2),-hole3)),-tube);
	}
   
void main( void )
	{
    vec2 p=-1.0+2.0*textureCoord.xy;
	vec3 dir=normalize(vec3(p*vec2(1.77,1.0),1.0));		// screen ratio (x,y) fov (z)
	//dir.yz=rotate(dir.yz,-PI*tan(PI*speed*.1)*0.153);	// rotation x
	dir.zx=rotate(dir.zx,.15*PI);				// rotation y
	dir.xy=rotate(dir.xy,-0.5*tan(PI*speed*.1)*0.153);					// rotation z
	vec3 ray=vec3(ground_x,ground_y,ground_z-speed*2.5);
	float t=0.0;
	for(int i=0;i<16;i++)
		{
		float k=draw_scene(ray+dir*t);
		t+=k*1.25;
		}
	vec3 hit=ray+dir*t;
	vec2 h=vec2(-0.0025,0.002); // light
	vec3 n=normalize(vec3(draw_scene(hit+h.xyx),draw_scene(hit+h.yxy),draw_scene(hit+h.yyx)));
	float c=(n.x+n.y+n.z)*0.35;
	vec3 color=vec3(c,c,c)+t*0.0625;
	gl_FragColor=vec4(vec3(c-t*0.30375+p.y*0.05,c-t*0.005-p.y*0.0025,c+t*0.005-p.y*0.005)+color*color,1.0);
	}