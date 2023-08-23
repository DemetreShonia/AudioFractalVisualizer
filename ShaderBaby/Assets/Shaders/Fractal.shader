
    Shader "ShaderMan/Fractal"
	{
	Properties{

        _MainTex ("Texture", 2D) = "white" {}


        _BulbType ("Bulb Type ID", Int) = 0
        _BulbTypeByRots ("Bulb Type Rots", Int) = 0
        _BulbTypeByUV ("Bulb Type UV", Int) = 0


        _Iteration ("Iteration Power", Range(2,10)) = 8
        _Moveness ("Moveness", Float) = 0
        _BulbScale ("Scale", Range(0.1,10)) = 1
        _Origin ("Camera Origin", Vector) = (0,0,0,0)
        _BulbRot ("Bulb Rot", Vector) = (0,0,0,0)

        _StartColor("Start Color", Color) = (0,0,0,0)
        _EndColor("End Color", Color) = (0,0,0,0)
	}
	SubShader
	{
	Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
	Pass
	{
	ZWrite Off
	Blend SrcAlpha OneMinusSrcAlpha
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#include "UnityCG.cginc"
			
    

    float4 vec4(float x,float y,float z,float w){return float4(x,y,z,w);}
    float4 vec4(float x){return float4(x,x,x,x);}
    float4 vec4(float2 x,float2 y){return float4(float2(x.x,x.y),float2(y.x,y.y));}
    float4 vec4(float3 x,float y){return float4(float3(x.x,x.y,x.z),y);}


    float3 vec3(float x,float y,float z){return float3(x,y,z);}
    float3 vec3(float x){return float3(x,x,x);}
    float3 vec3(float2 x,float y){return float3(float2(x.x,x.y),y);}

    float2 vec2(float x,float y){return float2(x,y);}
    float2 vec2(float x){return float2(x,x);}

    float vec(float x){return float(x);}
    
    

	struct VertexInput {
    float4 vertex : POSITION;
	float2 uv:TEXCOORD0;
    float4 tangent : TANGENT;
    float3 normal : NORMAL;

	//VertexInput
	};
	struct VertexOutput {
	float4 pos : SV_POSITION;
	float2 uv:TEXCOORD0;
	//VertexOutput
	};
	
	
	VertexOutput vert (VertexInput v)
	{
	VertexOutput o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = v.uv;
	//VertexFactory
	return o;
	}
    
    #define EPSILON 0.001
#define PI 3.141592
#define MAX_DIST 256.0
#define MAX_STEPS 256
#define it 10

float3 makeRay(float2 origin)
{
    return normalize(vec3(origin, 1.));
}

float2x2 rot(float a) 
{
    return float2x2(cos(a),sin(a),-sin(a),cos(a));	
}

float3 rotVec(float3 p, float3 r)
{
    p.yz =mul(p.yz,  rot(r.x));
    p.xz =mul(p.xz,  rot(r.y));
    p.xy =mul(p.xy,  rot(r.z));
    p.yz =mul(p.yz,  rot(r.x));
    return p;
}

float _Moveness;
int _BulbType;
int _BulbTypeByUV;
int _BulbTypeByRots;


float mandelBulb(float3 p, float3 fp, float power, float3 ang)
{
    p-= fp;
    p = rotVec(p, ang);
    
	float3 z = p;
	float r, theta, phi;
	float dr = 1.0;
	
	[unroll(100)]
    for(int i = 0; i < it; ++i)
    {
		r = length(z);
        
		if(r > 2.0)
            continue;
        
		theta = atan2(z.x,  z.y);

        switch(_BulbType){
            case 0:
                phi = asin(z.z / r)  + sin(_Time.y) + _Moveness * 30; //+ (_Time.y *0.01 + _Moveness * 10);
                break;
            case 1:
                phi = atan2(sin(z.x) , z.x) + _Time.y;
                break;
            case 2:
                phi = sin(sin(z.x)+ _Time.y) ;
                break;
            case 3:
                phi =  atan(z.z / r)  + sin(_Time.y) ;
                break;
        }

       // phi = asin(z.z / r) + _Time.y; _Moveness * 10; //+ (_Time.y *0.01 + _Moveness * 10);
        // cool with iter 8! and 1 !! phi = atan2(sin(z.x) , z.x) + _Time.y; _Moveness * 10; //+ (_Time.y *0.01 + _Moveness * 10);
        //phi = sin(sin(z.x) / tan(z.x)) + _Time.y; _Moveness * 10; //+ (_Time.y *0.01 + _Moveness * 10);
		


		dr = pow(r, power - 1.0) * dr * power + 1.0;
		r = pow(r, power);
        
		theta = theta * power;
		phi = phi * power;
		

        switch(_BulbTypeByRots)
        {
            case 0:
                z = r * vec3(cos(theta) * cos(phi),
                      sin(theta) * cos(phi), 
                      sin(phi)) + p;
                break;
            case 1:
                z = r * vec3(sin(theta) * sin (phi),
                      sin(theta) * cos(phi), 
                      sin(phi)) + p;
                break;
            case 2:
                z = r * vec3(cos(theta) * cos(phi),
                      sin(theta) * cos(phi), 
                      sin(phi)) + 2*p;
                break;
            case 3:
                z = r * vec3(cos(theta) * cos(phi),
                      sin(theta) * cos(phi), 
                      sin(phi)) + p * .1 ; // mult by calke cvladi??
                break;
        }

        

		// z = r * vec3(cos(theta) * cos(phi),
        //              sin(theta) * cos(phi), 
        //              sin(phi)) + p;


	}
    
	return 0.5 * log(r) * r / dr;
}

float _Iteration;
float _BulbScale;
float4 _EndColor;
float4 _StartColor;
float3 _BulbRot;

sampler2D _MainTex;

float getDist(float3 origin)
{
    // get signed distance to environment
    float3 fp = vec3(0);
    // GOOD PLACE FOR SLIDERS!
    float3 fr = PI *_BulbRot;// + _Time.y * 0.2;
    float power = _Iteration; // THE BEST PLACE!!
    
    return mandelBulb(origin, fp, power, fr);
}

float2 rayMarch(float3 origin, float3 direct)
{
    float res = 0.0;
    
    for (int i = 0; i < MAX_STEPS; i++)
    {
        float3 tmp = origin + direct * res;
        float d = getDist(tmp);
        res += d;
        
        if (res >= MAX_DIST || d < EPSILON)
        	return vec2(res, float(i));
    }

    return vec2(res, float(MAX_STEPS));
}
    float3 _Origin;
	fixed4 frag(VertexOutput vertex_output) : SV_Target
	{
	
    float3 origin = _Origin; // vec3(0, 0, -3); 
    
    // normalize UVs
    float2 uv = vertex_output.uv/1;
    uv -= 0.5;
    uv /= _BulbScale;


    // uv.y = uv.x + 1;
    
    // throw ray from pixel to forward
    float3 dir = makeRay(uv);   
    
    
    //dir.z += tan(_Time.y) * cos(dir.x); // cool fade in!
    // dir.y += tan(_Time.y) * tan(dir.x) * 0.01;
    float2 res = rayMarch(origin, dir);

    float3 col;

    float d = res.x;
    
    float3 startCol = vec3(0., cos(_Time.y) * 0.25 + 0.75, 0);
    float3 finCol = vec3(0, 0, sin(_Time.y) * 0.25 + 0.75);


    //startCol =_StartColor;
    //finCol = _EndColor;

    float delta = 0.5;
    
    if (d < MAX_DIST)
    {
    	float3 p = origin + d * dir;
        delta = length(p) / 2.0;
    }
    float mask =  res.y / float(MAX_STEPS) * 5.0;
    // if (mask < .5)
    //     mask = 0.1;

        col = lerp(startCol, finCol, delta) * mask;

        return vec4(col, 1);

    // float4 textureColor = tex2D(_MainTex, uv) * mask;



    // return vec4(col, 1) + textureColor;

	}
	ENDCG
	}
  }
}
