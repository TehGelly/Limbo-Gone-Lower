//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------


float opacity=1.0f;

texture g_txSrcColor;

sampler2D g_samSrcColor : register(s0) =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
};

#if defined(ORIGO_MAC)
float thresHold = 0.50;
#else
const float thresHold = 0.50;
#endif

//-----------------------------------------------------------------------------
// Pixel Shader: PostProcessPS
// Desc: Performs post-processing effect that inverts the image
//-----------------------------------------------------------------------------

float4 PostProcessPS(float2 tex : TEXCOORD0) : COLOR0
{
	float4 color = tex2D(g_samSrcColor, tex);
	float i = color.r;
	
	if(i < thresHold)
		i = 0;
	
	color.r = i;
	color.g = i;
	color.b = i;
	color.a = 1.0;

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
