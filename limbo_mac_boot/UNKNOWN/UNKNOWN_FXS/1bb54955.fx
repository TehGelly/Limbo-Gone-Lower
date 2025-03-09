//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------


float opacity=1.0f;
float color=1.0f;


texture g_txSrcColor;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
};


//-----------------------------------------------------------------------------
// Pixel Shader: PostProcessPS
// Desc: Performs post-processing effect that inverts the image
//-----------------------------------------------------------------------------

float4 PostProcessPS(float2 tex : TEXCOORD0) : COLOR0
{
    float4 c = 1.0f - tex2D(g_samSrcColor, tex);
    c = c * color;
    return float4(c.r, c.g, c.b, opacity); // RGBA
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
