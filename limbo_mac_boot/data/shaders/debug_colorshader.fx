float4x4 ViewProjMatrix;
float4x4 WorldMatrix;

float CameraZPos;
texture pTexture;

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
	//AddressU = Wrap;
	//AddressV = Wrap;
	MinFilter = Linear; //POINT
	MagFilter = Linear;
	MipFilter = Linear;
};


struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float4 Diffuse   : TEXCOORD6;
	float4 Specular  : TEXCOORD7;
	float4 TextureUV : TEXCOORD0;
};

// Specular use used as follows:
// the R component: fbrightness
// the G component: use fog flag (0 or 1)
// the B component: use blur flag (0 or 1)


VS_OUTPUT RenderObjectVS(float4 local_pos : POSITION, float3 normal : NORMAL, float4 diffuse : COLOR0, float4 specular : COLOR1, float2 uv0: TEXCOORD0)
{
	VS_OUTPUT Output;

	float4 world_pos = mul(local_pos,WorldMatrix);
	Output.Position = mul(world_pos,ViewProjMatrix); 

	Output.Diffuse = diffuse;
	Output.Specular = specular;
	// Note: The specular color is composed of special info about the render style:
	// Specular.a = unused
	// Specular.r = brightness
	// Specular.g = fog flag (0 or 1)
	// Specular.b = blur flag (0 or 1)
	Output.TextureUV.xy = uv0;
	Output.TextureUV.z = 0.0;
	
	// Compute fog factor (fog is 0 at z=0):
	float fog = pow(max(0.0, world_pos.z) * fFogDensity, fFogFalloff) * specular.y; // specular.y holds the fog flag (0 or 1)
	Output.Specular.g = 1.0 - (1.0f/exp(fog));
	// Note: Specular.g is now the fog factor, which the pixel shader can easily apply
	
	// Compute blur (blur focus depth is z=0):
	float dist_factor = abs((world_pos.z - CameraZPos) / CameraZPos);
	// dist_factor examples: 1.0=the exact focus depth, 2.0=twice the focus depth, 0.5=half the focus depth
	float d = log2(dist_factor) * specular.b; //specular.b holds the blur flag (0 or 1) and effectivly disables blur on the sprite.
	float blur = sqrt(abs(d))*fFocusFactor;
	if (d<0.0f)
		blur *= fFocusRatio;
	Output.TextureUV.w = clamp(blur, 0.0, 5.0);
	
	return Output;
}


float4 RenderObjectPS(float4 uv0 : TEXCOORD0, float4 diffuse : TEXCOORD6, float4 specular : TEXCOORD7) : COLOR0
{
	float4 pixel;
	//uv0 = clamp(uv0, 0.01, 0.99);
#if defined(ORIGO_MAC)
	pixel = tex2Dbias(TextureSampler, uv0.xy, uv0.w);
#else
	pixel = tex2Dbias(TextureSampler, uv0);
#endif
	pixel.rgb = diffuse.rgb;
	pixel.a = pixel.a * diffuse.a;
	
	// Apply brigthness:
	if (specular.r < 0.5) 
		pixel.rgb *= specular.r*2.0;
	else
	{
		float4 brightnessVec;
		brightnessVec.xyz = specular.r;
		pixel.rgb = lerp(pixel, 1.0, brightnessVec*2.0-1.0);
	}

	// Apply fog:
	pixel.rgb = lerp(pixel.rgb, iFogColor, specular.g);
	
	return float4(pixel.x, pixel.y, pixel.z, pixel.a);
}


technique RenderObjectNoLight
{
	pass p0
	{
		VertexShader = compile vs_2_0 RenderObjectVS();
		PixelShader = compile ps_2_0 RenderObjectPS();
	}
}


