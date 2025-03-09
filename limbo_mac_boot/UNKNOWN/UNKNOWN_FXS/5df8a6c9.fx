//-----------------------------------------------------------------------------
// File: op_invert.fx
//
// Desc: Effect file for image post-processing sample.  This effect contains
//       a single technique with a pixel shader that inverts the colors.
//-----------------------------------------------------------------------------


float4 opacity=float4(1.0f,1.0f,1.0f,1.0f);
float4 color=float4(1.0f,1.0f,1.0f,1.0f);
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
// Desc: Performs post-processing effect that inverts the image
//-----------------------------------------------------------------------------

float4 PostProcessPS(float2 tex1 : TEXCOORD0, float2 tex2 : TEXCOORD1) : COLOR0
{
    float4 bg_color = tex2D(g_samSrcColor, tex1);
    float4 tx_color = tex2D(g_samResource, tex2);
    return float4(bg_color.r, bg_color.g, bg_color.b, opacity.r*tx_color.a); // RGBA
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