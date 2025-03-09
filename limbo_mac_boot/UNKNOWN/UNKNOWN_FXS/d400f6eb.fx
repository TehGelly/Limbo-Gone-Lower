texture pTexture;
float4 textureFactor = 0;

float4x4 ViewProjMatrix;
float4x4 WorldMatrix;

float CameraZPos;

// Blur parameters:
//float fBlurFactor=0.0f;
float fFocusFactor;
float fFocusRatio;

// Fog parameters:
float4 iFogColor=1.0f;
float fFogDensity;
float fFogFalloff;


sampler2D TextureSampler : register(s0) =
sampler_state
{
	Texture = <pTexture>;
	AddressU = CLAMP;
	AddressV = CLAMP;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};


struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float4 Diffuse   : TEXCOORD6;
	float4 Specular  : TEXCOORD7; // This color entry has special meaning, see below
	float4 TextureUV : TEXCOORD0;
};

// Specular color is used as follows:
// the R component: fbrightness
// the G component: fog flag (0 or 1)
// the B component: blur flag (0 or 1)


VS_OUTPUT ParticleEmitterVS(float3 local_pos : POSITION,
							float3 normal : NORMAL,
							float4 diffuse : COLOR0,
							float4 specular : COLOR1,
							float2 uv0: TEXCOORD0)
{ 
	VS_OUTPUT Output;

	float4 world_pos = mul(float4(local_pos, 1),WorldMatrix);
	Output.Position = mul(world_pos,ViewProjMatrix); 
	Output.Diffuse = diffuse;
	Output.Specular = specular;
	Output.TextureUV.xy = uv0;
	Output.TextureUV.z = 0.0;
	Output.TextureUV.w = 0;

	// Compute fog factor (fog is 0 at z=0): 
/*	
	float fog = pow(world_pos.z * fFogDensity, fFogFalloff);
	fog = exp(fog);
	Output.Specular.r = lerp(iFogColor, Specular.r, 1.0f/fog);*/
	
	// Compute blur (blur focus depth is z=0):
/*	float dist_factor = abs((world_pos.z - CameraZPos) / CameraZPos);
	// dist_factor examples: 1.0=the exact focus depth, 2.0=twice the focus depth, 0.5=half the focus depth
	float d = log2(dist_factor);
	float blur = sqrt(abs(d))*fFocusFactor;
	if (d<0.0f)
		blur *= fFocusRatio;
	Output.TextureUV.w = clamp(blur, 0.0, 5.0);*/
	
	
	return Output;
}


float4 ParticleEmitterPS(VS_OUTPUT inVertexData) : COLOR0
{ 
	float4 pixel = tex2D(TextureSampler, inVertexData.TextureUV.xy);// * textureFactor;
	//pixel.rgb *= inVertexData.Diffuse;
	return pixel;
	//float4 pixel = tex2Dbias(TextureSampler, uv0) * color;
//
	//if (specular.r < 0.5) 
		//pixel.rgb *= specular.r*2.0;
	//else
	//{
		//float4 brightnessVec;
		//brightnessVec.xyz = specular.r;
		//pixel.rgb = lerp(pixel, 1.0, brightnessVec*2.0-1.0);
	//}
	//return float4(pixel.x, pixel.y, pixel.z, pixel.a);
}

technique ParticleEmitter
{
	pass p0
	{
		VertexShader = compile vs_2_0 ParticleEmitterVS();
		PixelShader = compile ps_2_0 ParticleEmitterPS();
	}
}
