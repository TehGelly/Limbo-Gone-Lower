// Water effect pixel shader

#define KERNEL0 5.0f
#define KERNEL1 32.0f
#define KERNEL2 100.0f
#define KERNEL3 100.0f
#define KERNEL4 100.0f
#define KERNEL5 32.0f
#define KERNEL6 5.0f

float pixelWidth = 0;
float opacity = 1.0f;
float brightness = 1.0f;
float4 viewport;
float hasTexture = 0.0f;

texture pBackGround;
sampler2D BackgroundSampler : register(s1) = 
sampler_state
{
	Texture = <pBackGround>;
	MinFilter = point;
	MagFilter = point;
	MipFilter = point;
};

texture pTexture;
sampler2D TextureSampler : register(s0) = 
sampler_state
{
	Texture = <pTexture>;
	MinFilter = linear;
	MagFilter = linear;
	MipFilter = linear;
};

struct VS_INPUT
{
	float4 Position  : POSITION;
	float4 Diffuse   : TEXCOORD6;
	float2 TextureUV : TEXCOORD0;
};

float4 main(float4 pos : VPOS, VS_INPUT vertexIn) : COLOR0
{
	float4 color = 0;

	float2 UV = pos.xy / viewport.zw;
	float2 offset = float2(-3, 0);
	float4 c = tex2D(BackgroundSampler, UV + offset) * KERNEL0;
	color += c;
	offset = float2(-2 * pixelWidth, 0);
	c = tex2D(BackgroundSampler, UV + offset) * KERNEL1;
	color += c;
	offset = float2(-1 * pixelWidth, 0);
	c = tex2D(BackgroundSampler, UV + offset) * KERNEL2;
	color += c;
	offset = float2(0 * pixelWidth, 0);
	c = tex2D(BackgroundSampler, UV + offset) * KERNEL3;
	color += c;
	offset = float2(1 * pixelWidth, 0);
	c = tex2D(BackgroundSampler, UV + offset) * KERNEL4;
	color += c;
	offset = float2(2 * pixelWidth, 0);
	c = tex2D(BackgroundSampler, UV + offset) * KERNEL5;
	color += c;
	offset = float2(3 * pixelWidth, 0);
	c = tex2D(BackgroundSampler, UV + offset) * KERNEL6;
	color += c;

	color /= KERNEL0 + KERNEL1 + KERNEL2 + KERNEL3 + KERNEL4 + KERNEL5 + KERNEL6;

	float alpha = 1.0;
//	if (hasTexture)
//	{
		float4 tex = tex2D(TextureSampler, vertexIn.TextureUV);
		color.rgb += tex.rgb;
		alpha = tex.a;
//	}
	color.r = lerp(color.r, vertexIn.Diffuse.r, opacity);
    return float4(color.r, 0, 0, alpha); // RGBA	
}
