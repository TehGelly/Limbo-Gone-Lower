//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------

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

//    1
//   1 1
//  1 2 1
// 1 3 3 1
//1 4 6 4 1
float pixelWidth = 0;
float pixelWidthX = 0;
float pixelWidthY = 0;
//-----------------------------------------------------------------------------
// Pixel Shader: BlurMinimalX and BlurMinimalY.
// Desc: Performs post-processing 3*3 blur of the image
//-----------------------------------------------------------------------------

float4 BlurMinimalX(float2 tex : TEXCOORD0) : COLOR0
{
    
	//return tex2D(TextureSampler, tex.xy);   // uncomment this if you want to remove the blurring (in x)
	
	float4 color = 0;
	
	float2 xOffset = float2(pixelWidth, 0);
	
	//color = tex2D(TextureSampler, tex.xy);
	
	// 3x3 kernel
	/*color += tex2D(TextureSampler, tex.xy - xOffset)*0.25;
	color += tex2D(TextureSampler, tex.xy)*0.5;
	color += tex2D(TextureSampler, tex.xy + xOffset)*0.25;*/
	
	// 4x4 kernel
	/*color += tex2D(TextureSampler, tex.xy - xOffset*1.5)*0.125;
	color += tex2D(TextureSampler, tex.xy - xOffset*0.5)*0.375;
	color += tex2D(TextureSampler, tex.xy + xOffset*0.5)*0.375;
	color += tex2D(TextureSampler, tex.xy + xOffset*1.5)*0.125;*/
	
	// 5x5 not-normalized kernel
	color += tex2D(TextureSampler, tex.xy - xOffset*2.0)*0.04;
	color += tex2D(TextureSampler, tex.xy - xOffset)*0.16;
	color += tex2D(TextureSampler, tex.xy)*0.6;
	color += tex2D(TextureSampler, tex.xy + xOffset)*0.16;
	color += tex2D(TextureSampler, tex.xy + xOffset*2.0)*0.04;
	
    return float4(color.r, color.g, color.b, color.a); // RGBA
}


float4 BlurMinimalY(float2 tex : TEXCOORD0) : COLOR0
{
    
	//return tex2D(TextureSampler, tex.xy);   // uncomment this if you want to remove the blurring (in y)
	
	float4 color = 0;
	
	float2 yOffset = float2(0, pixelWidth);
	
	// 3x3 kernel
	/*color += tex2D(TextureSampler, tex.xy - yOffset)*0.25;
	color += tex2D(TextureSampler, tex.xy)*0.5;
	color += tex2D(TextureSampler, tex.xy + yOffset)*0.25;*/

	// 4x4 kernel
	color += tex2D(TextureSampler, tex.xy - yOffset*1.5)*0.125;
	color += tex2D(TextureSampler, tex.xy - yOffset*0.5)*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*0.5)*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*1.5)*0.125;

	// 5x5 not-normalized kernel
	/*color += tex2D(TextureSampler, tex.xy - yOffset*2.0)*0.04;
	color += tex2D(TextureSampler, tex.xy - yOffset)*0.16;
	color += tex2D(TextureSampler, tex.xy)*0.6;
	color += tex2D(TextureSampler, tex.xy + yOffset)*0.16;
	color += tex2D(TextureSampler, tex.xy + yOffset*2.0)*0.04;*/
	
    return float4(color.r, color.g, color.b, color.a); // RGBA
}

float4 BlurMinimalXY(float2 tex : TEXCOORD0) : COLOR0
{
    
	//return tex2D(TextureSampler, tex.xy);   // uncomment this if you want to remove the blurring (in y)
	
	
	
	float4 color = 0;
	
	float2 yOffset = float2(0, pixelWidthY);
	float2 xOffset;
	
	// 5x4 kernel
	xOffset = float2(pixelWidthX, 0)*-2.0;
	color += tex2D(TextureSampler, tex.xy - yOffset*1.5 + xOffset)*0.04*0.125;
	color += tex2D(TextureSampler, tex.xy - yOffset*0.5 + xOffset)*0.04*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*0.5 + xOffset)*0.04*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*1.5 + xOffset)*0.04*0.125;

	xOffset = float2(pixelWidthX, 0)*-1.0;
	color += tex2D(TextureSampler, tex.xy - yOffset*1.5 + xOffset)*0.16*0.125;
	color += tex2D(TextureSampler, tex.xy - yOffset*0.5 + xOffset)*0.16*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*0.5 + xOffset)*0.16*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*1.5 + xOffset)*0.16*0.125;

	xOffset = float2(pixelWidthX, 0)*0.0;
	color += tex2D(TextureSampler, tex.xy - yOffset*1.5 + xOffset)*0.6*0.125;
	color += tex2D(TextureSampler, tex.xy - yOffset*0.5 + xOffset)*0.6*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*0.5 + xOffset)*0.6*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*1.5 + xOffset)*0.6*0.125;

	xOffset = float2(pixelWidthX, 0)*1.0;
	color += tex2D(TextureSampler, tex.xy - yOffset*1.5 + xOffset)*0.16*0.125;
	color += tex2D(TextureSampler, tex.xy - yOffset*0.5 + xOffset)*0.16*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*0.5 + xOffset)*0.16*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*1.5 + xOffset)*0.16*0.125;

	xOffset = float2(pixelWidthX, 0)*2.0;
	color += tex2D(TextureSampler, tex.xy - yOffset*1.5 + xOffset)*0.04*0.125;
	color += tex2D(TextureSampler, tex.xy - yOffset*0.5 + xOffset)*0.04*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*0.5 + xOffset)*0.04*0.375;
	color += tex2D(TextureSampler, tex.xy + yOffset*1.5 + xOffset)*0.04*0.125;	
	
    return float4(color.r, color.g, color.b, color.a); // RGBA
}
