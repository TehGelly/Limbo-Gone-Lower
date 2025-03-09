
struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float2 tex0 : TEXCOORD0;
	float2 tex1 : TEXCOORD1;
};

VS_OUTPUT main(float4 screen_pos : POSITION, float2 tex0 : TEXCOORD0, float2 tex1 : TEXCOORD1)
{
	VS_OUTPUT vOut;
	vOut.Position = screen_pos;
	vOut.tex0 = tex0;
	vOut.tex1 = tex1;
	return vOut;
}
