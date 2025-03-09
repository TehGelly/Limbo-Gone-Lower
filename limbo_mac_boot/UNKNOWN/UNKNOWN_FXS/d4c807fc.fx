//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------


float opacity=1.0f;
float brightness=1.0f;

texture g_txSrcColor;

sampler2D g_samSrcColor : register(s0) =
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
	5.0,
	32.0,
	100.0,
	100.0,
	100.0,
	32.0,
	5.0
};

float pixelWidth = 0;

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

	// brightness		
	color.r = 2.0*brightness*color.r;
	color.g = 2.0*brightness*color.g;
	color.b = 2.0*brightness*color.b;

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
