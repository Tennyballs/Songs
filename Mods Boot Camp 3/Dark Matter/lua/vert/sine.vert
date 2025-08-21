#define PI 3.14159265

varying vec4 color;
varying vec2 textureCoord;
uniform float howmany;
uniform float mode;

uniform bool isHold;
uniform int iCol;
uniform float beat;
uniform float fYOffset;

uniform float fNoteBeat;
uniform float nbeat;
uniform float amp; // amplitude. Can be any number. 0 turns it off
uniform float amp2; // same
uniform float per; // determines how thicc your waveform is
uniform float per2; // same
uniform float wave; // use this to change the waveform
uniform float gravity; // use this to change the waveform



uniform int iPlayfield;
uniform vec2 resolution;

uniform mat4 modelMatrix;

// ------

// simple 2D rotation matrix
//mat2 rotate2D( float t ) { return mat2( cos( t ), sin( t ), -sin( t ), cos( t ) ); }

// already implemented on GLSL 1.40, but some environment says no
mat4 inverse( mat4 m ) {
  float
    a00 = m[0][0], a01 = m[0][1], a02 = m[0][2], a03 = m[0][3],
    a10 = m[1][0], a11 = m[1][1], a12 = m[1][2], a13 = m[1][3],
    a20 = m[2][0], a21 = m[2][1], a22 = m[2][2], a23 = m[2][3],
    a30 = m[3][0], a31 = m[3][1], a32 = m[3][2], a33 = m[3][3],

    b00 = a00 * a11 - a01 * a10,
    b01 = a00 * a12 - a02 * a10,
    b02 = a00 * a13 - a03 * a10,
    b03 = a01 * a12 - a02 * a11,
    b04 = a01 * a13 - a03 * a11,
    b05 = a02 * a13 - a03 * a12,
    b06 = a20 * a31 - a21 * a30,
    b07 = a20 * a32 - a22 * a30,
    b08 = a20 * a33 - a23 * a30,
    b09 = a21 * a32 - a22 * a31,
    b10 = a21 * a33 - a23 * a31,
    b11 = a22 * a33 - a23 * a32,

    det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

  return mat4(
    a11 * b11 - a12 * b10 + a13 * b09,
    a02 * b10 - a01 * b11 - a03 * b09,
    a31 * b05 - a32 * b04 + a33 * b03,
    a22 * b04 - a21 * b05 - a23 * b03,
    a12 * b08 - a10 * b11 - a13 * b07,
    a00 * b11 - a02 * b08 + a03 * b07,
    a32 * b02 - a30 * b05 - a33 * b01,
    a20 * b05 - a22 * b02 + a23 * b01,
    a10 * b10 - a11 * b08 + a13 * b06,
    a01 * b08 - a00 * b10 - a03 * b06,
    a30 * b04 - a31 * b02 + a33 * b00,
    a21 * b02 - a20 * b04 - a23 * b00,
    a11 * b07 - a10 * b09 - a12 * b06,
    a00 * b09 - a01 * b07 + a02 * b06,
    a31 * b01 - a30 * b03 - a32 * b00,
    a20 * b03 - a21 * b01 + a22 * b00
  ) / det;
}

// ------

void main() {
  // get model matrix (contains translate, rotate, scale and skew)
  mat4 mat = modelMatrix;

//This is a shader I based on FMS_Cat's twister shader. I still don't fully understand how all this works but hey, I managed to do something
  vec4 transCenter = vec4( resolution.x / 4.0 * ( 2.0 * float( 0.5 ) + 1.0 ), resolution.y / 4.0, 0.0, 0.0 );
  vec4 transCentery = vec4( resolution.y / 4.0 * ( 2.0 * float( 0.5 ) + 1.0 ), resolution.x / 4.0, 0.0, 0.0 );


  vec4 vert = mat * vec4( gl_Vertex.xyz, 1.0 );
  vert = vert - 0.0;

	
 int vID=gl_VertexID;

	




				//vert.x+=sin(vert.y*.02)*20;
				//vert.x=clamp(vert.x,0,400);
				

					
					//vert.x+=exp((vert.y-350)*0.04)*clamp(vert.x-transCenter,-1,1);
					vert.x+=clamp(sin(vert.y*0.08)*(exp((vert.y-200)*0.1)*5),-70,70); //tää on aika harza
					//vert.x+=round(sin(vert.y*0.1))*(exp((clamp(vert.y-300,-50,50))*0.05)*10); //tääkin on harza
					
					//vert.x+=tan(vert.y*0.1)*1;
					//vert.x+=exp((vert.y-100)*0.02)*clamp(vert.x-transCenter,-1,1);
					 //vert.x+=floor(sin(vert.y*.05))*20;
					//vert.x-=exp(vert.x-600)*0.02;
					/*
					if(vert.x<(transCenter.x-240)){
						
						vert.x=transCenter.x-240;
					}
					else if(vert.x>(transCenter.x+240)){
						
						vert.x=transCenter.x+240;
					}
					*/
					// vert.y+=floor(cos(vert.y*.05))*30;
					// vert.y=+sin(vert.x);
					//vert.y+=exp((vert.y-350)*0.05)*abs(clamp(vert.x-transCenter,-1,0));
					//vert.y-=exp((vert.y+200)*0.007);
					//vert.y+=exp(vert.z*0.001)*1;
					
					//if(vert.y<300){
						
						//vert.y+=exp( (vert.y-400)*-0.04)*-1;
					//}

				
			
			
		
	
	
	
	
  // back to previous state except rotation
  vert = vert + 0.0;
  vert = inverse( mat ) * vert;

  // ====== rest is almost same as nop.vert ======

  gl_Position = (gl_ModelViewProjectionMatrix * vert);

  gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
  textureCoord = gl_TexCoord[0].xy;

  gl_FrontColor = gl_Color;
  color = gl_Color;
}