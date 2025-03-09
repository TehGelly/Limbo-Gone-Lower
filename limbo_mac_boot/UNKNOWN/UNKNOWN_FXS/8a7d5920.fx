//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------


float4 opacity=float4(1.0f,1.0f,1.0f,1.0f);
float4 color=float4(1.0f,1.0f,1.0f,1.0f);


texture g_txSrcColor;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

//-----------------------------------------------------------------------------
// Pixel Shader: PostProcessPS
//-----------------------------------------------------------------------------

float4 PostProcessPS(float2 tex : TEXCOORD0) : COLOR0
{
   float4 c = tex2D(g_samSrcColor, tex);
   c.a = opacity;
   return c;
}




//-----------------------------------------------------------------------------
// Technique: PostProcess
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
