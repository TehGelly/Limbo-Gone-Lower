// Water effect vertex shader

// For 3D rendering
float4x4 ViewProjMatrix;
float4x4 WorldMatrix;
float4 viewport;

float bias;

struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float4 Diffuse   : TEXCOORD6;
	float2 textureUV : TEXCOORD0;
};

VS_OUTPUT main(float3 local_pos : POSITION, float4 diffuse : TEXCOORD6, float2 textureUV : TEXCOORD0)
{
	VS_OUTPUT vOut;
	float4 world_pos = mul(float4(local_pos, 1),WorldMatrix);
	vOut.Position = mul(world_pos,ViewProjMatrix); 
	vOut.Position.z -= bias * 0.001;
	vOut.Diffuse = diffuse;
	vOut.textureUV = textureUV;
	return vOut;
}
