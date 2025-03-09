//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------


float opacity=1.0f;

texture g_txSrcColor;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;//Linear
    MipFilter = Linear;//Linear
};


const float kernel[7] = {
	100.0,
	100.0,
	100.0,
	100.0,
	100.0,
	100.0,
	100.0
};

#if defined(ORIGO_MAC)
float pixelWidth = 0;
#else
const float pixelWidth = 0;
#endif

//-----------------------------------------------------------------------------
// Pixel Shader: PostProcessPS
// Desc: Performs post-processing effect that inverts the image
//-----------------------------------------------------------------------------

float4 PostProcessPS(float2 tex : TEXCOORD0) : COLOR0
{
    
	float4 color = 0;
	
	for(int i = -3; i < 4; i++)
	{
		float2 offset = float2(i * pixelWidth, 0);
		float4 c = tex2D(g_samSrcColor, tex + offset) * kernel[i + 3];
		color = color + c;
	}

	color.r = color.r / 374.0;
	color.g = color.g / 374.0;
	color.b = color.b / 374.0;

    return float4(color.r, color.g, color.b, opacity); // RGBA
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
