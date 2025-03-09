//-----------------------------------------------------------------------------
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that applies a texture with addsigned blend.
//-----------------------------------------------------------------------------


float opacity=1.0f;
float4 color=1.0f;

float pixelWidth;

float totalTime;

texture g_txSrcColor;
texture g_txResource;

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

sampler2D g_samResource : register(s1) =
sampler_state
{
    Texture = <g_txResource>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
};

//-----------------------------------------------------------------------------
// Pixel Shader: PostProcessPS
// Desc: Performs post-processing effect that applies a texture using addsigned blend
//-----------------------------------------------------------------------------



float4 PostProcessPS(float2 tex1 : TEXCOORD0, float2 tex2 : TEXCOORD1) : COLOR0
{
    float4 tx_color = tex2D(g_samResource, tex2);
	
	float2 tex_offset = float2(tx_color.a * pixelWidth * sin(5 * totalTime + 3.14) * 1, tx_color.a * pixelWidth * sin(tex1.y * 12 + totalTime * 4) * 0.5);
	return tex2D(g_samSrcColor, tex1 + tex_offset);
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
