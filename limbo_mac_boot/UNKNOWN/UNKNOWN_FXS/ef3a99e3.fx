//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------


float4 opacity = float4(1.0f,1.0f,1.0f,1.0f);
float4 color = float4(1.0f,1.0f,1.0f,1.0f);

texture g_txSrcColor;

sampler2D TextureSampler : register(s0) =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
};
// 1,14,91,364,1001,2002,3003,3432 (removed 2 smallest terms)
#define KERNEL0 0.0091f
#define KERNEL1 0.0364f
#define KERNEL2 0.1001f
#define KERNEL3 0.2002f
#define KERNEL4 0.3003f
#define KERNEL5 0.3432f

#define HALFKERNELSIZE 5

float pixelWidth = 0;

//-----------------------------------------------------------------------------
// Pixel Shader: PostProcessPS
// Desc: Performs post-processing effect that inverts the image
//-----------------------------------------------------------------------------

float4 PostProcessPS(float2 tex : TEXCOORD0) : COLOR0
{
    
	float4 color = 0;
	
	float2 offset = float2(0, -HALFKERNELSIZE*pixelWidth);
	float4 c = tex2D(TextureSampler, tex.xy + offset) * KERNEL0;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL1;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL2;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL3;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL4;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL5;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL4;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL3;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL2;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL1;
	color += c;
	offset.y += pixelWidth;
	c = tex2D(TextureSampler, tex.xy + offset) * KERNEL0;
	color += c;

	color /= (KERNEL0*2 + KERNEL1*2 + KERNEL2*2 + KERNEL3*2 + KERNEL4*2 + KERNEL5);
	
    return float4(color.r, color.g, color.b, color.a); // RGBA
}




//-----------------------------------------------------------------------------
// Technique: PostProcess
// Desc: Performs post-processing effect that inverts the image
//-----------------------------------------------------------------------------
technique PostProcess
{
    pass p0
    {
        VertexShader = null;
        PixelShader = compile ps_2_0 PostProcessPS();
        ZEnable = false;
    }
}
