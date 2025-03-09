float4x4 ViewProjMatrix;
float4x4 WorldMatrix;

texture pTexture;

// Fog parameters:
float4 iFogColor=1.0f;
float fFogDensity;
float fFogFalloff;


struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float4 Diffuse   : TEXCOORD6;
	float4 Specular  : TEXCOORD7;
};


VS_OUTPUT CollisionObjectVS(float4 local_pos : POSITION, float4 specular : COLOR0)
{
	VS_OUTPUT Output;
	
	float4 world_pos = mul(local_pos,WorldMatrix);
	Output.Position = mul(world_pos,ViewProjMatrix); 
	Output.Diffuse = float4(0.0, 0.0, 0.0, specular.a);
	Output.Specular = specular;
	// Note: The specular color is composed of special info about the render style:
	// Specular.a = opacity
	// Specular.r = brightness
	// Specular.g = fog flag (0 or 1)
	// Specular.b = unused
	
	// Compute fog factor (fog is 0 at z=0):
	float fog = pow(max(0.0, world_pos.z) * fFogDensity, fFogFalloff) * specular.y; // specular.y holds the fog flag (0 or 1)
	Output.Specular.g = 1.0 - (1.0f/exp(fog));
	// Note: Specular.g is now the fog factor, which the pixel shader can easily apply
	
	return Output;
}


float4 CollisionObjectPS(float4 diffuse : TEXCOORD6, float4 specular : TEXCOORD7) : COLOR0
{
	float4 pixel;
	pixel = diffuse;
	
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
		VertexShader = compile vs_2_0 CollisionObjectVS();
		PixelShader = compile ps_2_0 CollisionObjectPS();
	}
}


