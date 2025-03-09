float4x4 ViewProjMatrix;
float4x4 WorldMatrix;
float4 viewport;
float CameraZPos;
float hasTexture = 0.0f;
texture pTexture0;
texture pTexture1;

// Blur parameters:
float fFocusFactor;
float fFocusRatio;

// Fog parameters:
float4 iFogColor; // w = iBiasScale
float fFogDensity;
float fFogFalloff;

sampler2D TextureSampler : register(s0)  =
sampler_state
{
	Texture = <pTexture0>;
	//AddressU = Wrap;
	//AddressV = Wrap;
	MinFilter = Linear; //POINT
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler2D BackBufferSampler : register(s1) = 
sampler_state
{
	Texture = <pTexture1>;
	AddressU = Clamp;
	AddressV = Clamp;
	MinFilter = Linear; //POINT
	MagFilter = Linear;
	MipFilter = Linear;
};

struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float4 Diffuse   : TEXCOORD6; // diffuse(r,a):xy, specular(r,a);zw
	float4 TextureUV : TEXCOORD0; // xy: uv, w:lod, z:fog
};

// Specular use used as follows:
// the R component: fbrightness
// the G component: use fog flag (0 or 1)
// the B component: use blur flag (0 or 1)

VS_OUTPUT RenderObjectVS(float4 local_pos : POSITION, float4 diffuse : COLOR0, float4 specular : COLOR1, float2 uv0: TEXCOORD0)
{
	VS_OUTPUT Output;

	float4 world_pos = mul(local_pos, WorldMatrix);
	Output.Position = mul(world_pos, ViewProjMatrix);
	Output.Diffuse.xy = diffuse.xw;
	Output.Diffuse.zw = specular.xw;
	// Note: The specular color is composed of special info about the render style:
	// Specular.a = bloom
	// Specular.r = brightness
	// Specular.g = fog flag (0 or 1)
	// Specular.b = blur factor (0.25 maps to 1)
	Output.TextureUV.xy = uv0;
	
	// Compute fog factor (fog is 0 at z=0):
	float fog = pow(max(0.0, world_pos.z) * fFogDensity, fFogFalloff) * specular.y; // specular.y holds the fog flag (0 or 1)
	Output.TextureUV.z = 1.0 - (1.0f/exp(fog));
	// Note: TextureUV.z is now the fog factor, which the pixel shader can easily apply

	// Compute blur (blur focus depth is z=0):
	float bluroffset = specular.b * 4.0 - 1.0; // usualy blur is 0.25 except for 2d sprites
	float dist_factor = abs((world_pos.z - CameraZPos + bluroffset) / CameraZPos);	
	// dist_factor examples: 1.0=the exact focus depth, 2.0=twice the focus depth, 0.5=half the focus depth
	float d = log2(dist_factor) * specular.b * 4.0; //specular.b holds the blur factor (0.25 maps to one) and effectivly disables blur on the sprite.
	float blur = sqrt(abs(d))*fFocusFactor;
	if (d<0.0f)
		blur *= fFocusRatio;
	Output.TextureUV.w = clamp(blur, 0.0, 5.0);
	
	return Output;
}

float4 RenderObjectPS( float4 uv0 : TEXCOORD0, float4 diffuse : TEXCOORD6) : COLOR0
{
	float4 pixel = 0;
	uv0.w += iFogColor.w;
#if defined(ORIGO_MAC)
	pixel.xw = tex2Dbias(TextureSampler, uv0.xy, uv0.w).xw * diffuse.xy;
#else
	pixel.xw = tex2Dbias(TextureSampler, uv0).xw * diffuse.xy;
#endif

	// Apply brigthness:
	float brightness = diffuse.z*2.0;
	float median = brightness-1.0;
	float2 alpha_offset = float2(brightness, 0);
	if (median >= 0.0) {
		alpha_offset = float2(2.0-brightness, median);
	}
	pixel.r = pixel.r*alpha_offset.x + alpha_offset.y;
	
	// Apply fog:
	pixel.r = lerp(pixel.r, iFogColor.r, uv0.z);
	pixel = float4(pixel.r, pixel.r * diffuse.a /* add bloom */, 0, pixel.a);

	return pixel;
}

float4 RenderObjectEffectPS(float4 pixelPos : VPOS, float4 uv0 : TEXCOORD0, float4 diffuse : TEXCOORD6) : COLOR0
{	
	float4 pixel = 0;
	uv0.w += iFogColor.w;
#if defined(ORIGO_MAC)
	pixel.xw = tex2Dbias(TextureSampler, uv0.xy, uv0.w).xw * diffuse.xy;
#else
	pixel.xw = tex2Dbias(TextureSampler, uv0).xw * diffuse.xy;
#endif

	// Apply brigthness:
	float brightness = diffuse.z*2.0;
	float median = brightness-1.0;
	float offset = 0;
	float alpha = brightness;
	if (median > 0.0) {
		offset = median;
		alpha = 2.0-brightness;
	}
	pixel.r = pixel.r*alpha + offset;
	float4 effectTexel = tex2D(BackBufferSampler, pixelPos.xy / viewport.zw);
	pixel.r *= effectTexel.r;

	// Apply fog:
	pixel.r = lerp(pixel.r, iFogColor.r, uv0.z);
	pixel = float4(pixel.r, pixel.r * diffuse.a /* add bloom */, 0, pixel.a);

	return pixel;
}

float4 DebugPS(float4 uv0 : TEXCOORD0, float4 diffuse : TEXCOORD6) : COLOR0
{
	float4 pixel;
	pixel = tex2D(TextureSampler, uv0);
	return pixel;
}

float4 RefractionPS(float4 pos: VPOS, float4 uv : TEXCOORD0, float4 diffuse: TEXCOORD6) : COLOR0
{
	float4 texel = tex2D(TextureSampler, uv.xy);
	float4 normal = texel * 2.0f - 1.0f;
	float2 pixelWidthHeight = float2(1.0/viewport.z, 1.0/viewport.w);
	float2 offset = normal.ba * pixelWidthHeight * 100 * diffuse.y;  // max 10 pixels distortion
	float2 backBufferUV  = pos.xy / viewport.zw;
	float4 pixel = float4(( tex2D(BackBufferSampler, backBufferUV + offset).xyz * diffuse.rrr).rgb, 1.0f);
	return pixel;
}


    