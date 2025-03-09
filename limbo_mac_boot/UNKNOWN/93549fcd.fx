float4x4 ViewProjMatrix;
float4x4 WorldMatrix;

struct VS_OUTPUT
{
	float4 Position  : POSITION;
};


VS_OUTPUT RenderObjectVS(float4 local_pos : POSITION)
{
	VS_OUTPUT Output;

	float4 world_pos = mul(local_pos,WorldMatrix);
	Output.Position = mul(world_pos,ViewProjMatrix); 

	return Output;
}


float4 RenderObjectPS() : COLOR0
{
	return float4(1.0,0.0,1.0,1.0);
}


technique RenderObjectNoLight
{
	pass p0
	{
		VertexShader = compile vs_2_0 RenderObjectVS();
		PixelShader = compile ps_2_0 RenderObjectPS();
	}
}


