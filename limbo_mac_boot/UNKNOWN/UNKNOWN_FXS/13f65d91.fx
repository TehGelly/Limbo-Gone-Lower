// Replacement for fixed function rendering

// For 3D rendering
uniform float4x4 ViewProjMatrix;
uniform float4x4 WorldMatrix;

// For 2D rendering
uniform float4 viewport;

uniform float CameraZPos;
uniform float bias;
uniform float4 textureFactor;
uniform float brightness;
uniform float contrast;
uniform float gamma;

texture pTexture;
texture pBloom;

// Blur parameters:
uniform bool doBlur;
uniform float fFocusFactor;
uniform float fFocusRatio;

uniform float fBlackWarning;

sampler2D TextureSampler : register(s0) = 
sampler_state
{
	Texture = <pTexture>;
	//AddressU = CLAMP;
	//AddressV = CLAMP;
	MinFilter = Linear; //POINT
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler2D BloomSampler : register(s1) = 
sampler_state
{
	Texture = <pBloom>;
	//AddressU = CLAMP;
	//AddressV = CLAMP;
	MinFilter = Linear; //POINT
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler2D NoiseSampler : register(s2) = 
sampler_state
{
	Texture = <pNoise>;
	MinFilter = Linear; 
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler2D LeftEyeSampler : register(s0) = 
sampler_state
{
	Texture = <pLeft>;
	//AddressU = CLAMP;
	//AddressV = CLAMP;
	MinFilter = Point; //POINT
	MagFilter = Point;
	MipFilter = Point;
};

sampler2D RightEyeSampler : register(s1) = 
sampler_state
{
	Texture = <pRight>;
	//AddressU = CLAMP;
	//AddressV = CLAMP;
	MinFilter = Point; //POINT
	MagFilter = Point;
	MipFilter = Point;
};

sampler2D ColorCodeSampler : register(s2) = 
sampler_state
{
	Texture = <pColorCode>;
	//AddressU = CLAMP;
	//AddressV = CLAMP;
	MinFilter = Point; //POINT
	MagFilter = Point;
	MipFilter = Point;
};


struct VS_OUTPUT
{
	float4 Position  : POSITION;
	float4 UV        : TEXCOORD0;
	float4 Diffuse   : TEXCOORD6;
};

// --- 2DUV
VS_OUTPUT FixedFunction2DUVVS(float4 screen_pos : POSITION, float2 textureUV : TEXCOORD0)
{
	VS_OUTPUT vOut;
	vOut.Position.xy = ((screen_pos.xy)/viewport.zw)*float2(2.0, -2.0)+float2(-1.0, 1.0);
	vOut.Position.zw = screen_pos.zw;
	vOut.Diffuse = float4(1,1,1,1);
	vOut.UV = float4(textureUV.x, textureUV.y, 0, 0);
	return vOut;
}

float4 FixedFunction2DUVPS(VS_OUTPUT vertexIn) : COLOR0
{
	return tex2D(TextureSampler, vertexIn.UV.xy) * textureFactor + float4(brightness, brightness, brightness, 0.0f);
}

float4 FixedFunction2DUVExpandRedPS(VS_OUTPUT vertexIn) : COLOR0
{
	// Merge blue into red, to add the bloom effect
	float4 color = tex2D(TextureSampler, vertexIn.UV.xy);
	color.r += color.g;
	color.g = color.r+0.0013;
	color.b = color.r+0.0026;
	return color;
}

float4 FixedFunction2DUVBrightnessContrastPS(VS_OUTPUT vertexIn) : COLOR0
{
	float4 tex = tex2D(TextureSampler, vertexIn.UV.xy);
	
	
	// the right way:
	float4 fullscaleval = tex*(2.0-tex*tex); // = tex + (tex-tex*tex*tex);
	tex = tex*(1.0-gamma)+ fullscaleval*gamma + brightness;
	return (tex - 0.5f) * (1 + (contrast - 1) * 0.5) + 0.5f;
	
	/*// test:
	
	float cutval = 0.25-brightness*0.25;
	if (tex.x<=cutval) {
		//return ((0.5-cutval)/cutval)*tex;
		return tex;
	} else if (tex.x<0.5) {
		return tex;
		float a=cutval/(0.5-cutval);
		return 0.5-0.5*a+a*tex;
	} else {
		return tex;
	}*/
	
}

// --- 2DColorUV
VS_OUTPUT FixedFunction2DColorUVVS(float4 screen_pos : POSITION, float4 color : COLOR0, float2 textureUV : TEXCOORD0)
{
	VS_OUTPUT vOut;
	vOut.Position.xy = ((screen_pos.xy)/viewport.zw)*float2(2.0, -2.0)+float2(-1.0, 1.0);
	vOut.Position.zw = screen_pos.zw;
	vOut.Diffuse = color;
	vOut.UV = float4(textureUV, 0, 0);
	return vOut;
}

float4 FixedFunction2DColorUVPS(VS_OUTPUT vertexIn) : COLOR0
{
	return tex2D(TextureSampler, vertexIn.UV.xy) * vertexIn.Diffuse * textureFactor + float4(brightness, brightness, brightness, 0.0f);
}

// --- 2DColorUV2DPost

struct VS_OUTPUT_POST
{
	float4 Position  : POSITION;
	float4 UV        : TEXCOORD0;
};

VS_OUTPUT_POST FixedFunction2DColorUV2PostVS(float4 screen_pos : POSITION, float2 textureUV : TEXCOORD0, float2 bloomUV : TEXCOORD1)
{
	VS_OUTPUT_POST vOut;
	vOut.Position.xy = ((screen_pos.xy)/viewport.zw)*float2(2.0, -2.0)+float2(-1.0, 1.0);
	vOut.Position.zw = screen_pos.zw;
	vOut.UV = float4(textureUV.x, textureUV.y, bloomUV.x, bloomUV.y);
	return vOut;
}

float4 randomInfo;
float4 FixedFunction2DColorUV2PostPS(VS_OUTPUT_POST vertexIn) : COLOR0
{
	// 1280/256 = 5.0, 720/256 = 2.81
	float noise = tex2D(NoiseSampler, vertexIn.UV.xy*float2(5.0,2.81)+randomInfo.xy).r*2.0-1.0;		
	// Merge blue into red, to add the bloom effect
	float4 color = tex2D(TextureSampler, vertexIn.UV.xy);
	// DANIELSUGLYHACKTOREMOVESTRETCHEDEYESBUG
	float4 bloom = tex2D(BloomSampler, vertexIn.UV.zw);
	float tex = color.r + color.g + bloom.g;	
	//float tex = color.r + color.g;	 
	tex = clamp(tex,0.0,1.0);

	float fullscaleval = tex*(2.0-tex*tex); // = tex + (tex-tex*tex*tex);
	float gammaScale = (1.0f-tex);
	gammaScale *= gammaScale*gammaScale*2.0*gamma;
	tex = tex*(1.0-gammaScale)+ fullscaleval*gammaScale + brightness;
	tex = (tex - 0.5f) * (1 + (contrast - 1) * 0.5) + 0.5f;

	// test:	
	tex = tex*(noise*randomInfo.w+1.0) + (noise*randomInfo.z); // apply grain multiply

	tex = clamp(tex,0.0,1.0);
	
	color.r = tex;
	color.g = tex+0.0013;
	color.b = tex+0.0026;
	color.a = 1;


	return color;
}


float4 FixedFunction2DColorUV2PostPS_BlackWarning(VS_OUTPUT_POST vertexIn) : COLOR0
{
	// Merge blue into red, to add the bloom effect
	float4 color = tex2D(TextureSampler, vertexIn.UV.xy);
	float4 bloom = tex2D(BloomSampler, vertexIn.UV.zw);
	float tex = color.r + color.g + bloom.g;
	
	float fullscaleval = tex*(2.0-tex*tex); // = tex + (tex-tex*tex*tex);
	float gammaScale = (1.0f-tex);
	gammaScale *= gammaScale*gammaScale*2.0*gamma;
	tex = tex*(1.0-gammaScale)+ fullscaleval*gammaScale + brightness;
	tex = (tex - 0.5f) * (1 + (contrast - 1) * 0.5) + 0.5f;

	color.r = tex;
	color.g = tex+0.0013;
	color.b = tex+0.0026;
	color.a = 1;
	
	if (color.r<fBlackWarning)
		color.r = 1.0;
	return color;
}


// --- 2DColor
VS_OUTPUT FixedFunction2DColorVS(float4 screen_pos : POSITION, float4 color : COLOR0)
{
	VS_OUTPUT vOut;
	vOut.Position.xy = ((screen_pos.xy)/viewport.zw)*float2(2.0, -2.0)+float2(-1.0, 1.0);
	vOut.Position.zw = screen_pos.zw;
	vOut.Diffuse = color;
	vOut.UV = 0;
	return vOut;
}

float4 FixedFunction2DColorPS(VS_OUTPUT vertexIn) : COLOR0
{
	return vertexIn.Diffuse * textureFactor + float4(brightness, brightness, brightness, 0.0f);
}


// --- 3D Color
VS_OUTPUT FixedFunction3DColorVS(float3 local_pos : POSITION, float4 diffuse : COLOR0)
{
	VS_OUTPUT vOut;
	float4 world_pos = mul(float4(local_pos, 1),WorldMatrix);
	vOut.Position = mul(world_pos,ViewProjMatrix); 
	vOut.Position.z -= bias * 0.001;
	vOut.Diffuse = diffuse;
	vOut.UV = 0;
	return vOut;
}


float4 FixedFunction3DColorPS(VS_OUTPUT vertexIn) : COLOR0
{
	return vertexIn.Diffuse * textureFactor + float4(brightness, brightness, brightness, 0.0f);
}

// --- 3D 
VS_OUTPUT FixedFunction3DVS(float3 local_pos : POSITION)
{
	VS_OUTPUT vOut;
	float4 world_pos = mul(float4(local_pos, 1),WorldMatrix);
	vOut.Position = mul(world_pos,ViewProjMatrix); 
	vOut.Position.z -= bias * 0.001;
	vOut.Diffuse = float4(1,1,1,1);
	vOut.UV = 0;
	return vOut;
}

float4 FixedFunction3DPS(VS_OUTPUT vertexIn) : COLOR0
{
	return textureFactor + float4(brightness, brightness, brightness, 0.0f);
}


// --- 3D Color UV
VS_OUTPUT FixedFunction3DColorUVVS(float3 local_pos : POSITION, float4 diffuse : COLOR0, float2 uv : TEXCOORD0)
{
	VS_OUTPUT vOut;
	float4 world_pos = mul(float4(local_pos, 1),WorldMatrix);
	vOut.Position = mul(world_pos,ViewProjMatrix); 
	vOut.Position.z -= bias * 0.001;
	vOut.Diffuse = diffuse;
	vOut.UV = float4(uv, 0, 0);
	return vOut;
}

float4 FixedFunction3DColorUVPS(VS_OUTPUT vertexIn) : COLOR0
{
	float4 texel = tex2D(TextureSampler, vertexIn.UV.xy);
	float4 color = vertexIn.Diffuse;
	color.a *= texel.a;
	return color;
}

// --- 3D Color Specular UV
VS_OUTPUT FixedFunction3DColorSpecularUVVS(float4 local_pos : POSITION, float4 diffuse : COLOR0, float4 specular : COLOR1, float2 uv: TEXCOORD0)
{
	VS_OUTPUT vOut;
	float4 world_pos = mul(local_pos,WorldMatrix);
	vOut.Position = mul(world_pos,ViewProjMatrix);
	vOut.Position.z -= bias * 0.001;
	vOut.Diffuse = diffuse;
	vOut.UV = float4(uv, 0, 0);
	return vOut;
}

float4 FixedFunction3DColorSpecularUVPS(VS_OUTPUT vertexIn) : COLOR0
{
	float4 texel = tex2D(TextureSampler, vertexIn.UV.xy);
	float4 color = vertexIn.Diffuse;
	color.a *= texel.a;
	return color;
}

float4 FixedFunctionOverDrawPS(VS_OUTPUT vertexIn) : COLOR0
{
	float4 texel = tex2D(TextureSampler, vertexIn.UV.xy);
	return float4(16.0/255.0,0,0,texel.a);
}

// --- 3D Normal UV
VS_OUTPUT FixedFunction3DNUVVS(float3 local_pos : POSITION, float3 normal : NORMAL, float2 UV : TEXCOORD0)
{
	VS_OUTPUT vOut;
	float4 world_pos = mul(float4(local_pos, 1),WorldMatrix);
	vOut.Position = mul(world_pos,ViewProjMatrix); 
	vOut.Position.z -= bias * 0.001;
	vOut.Diffuse = float4(1,1,1,1);
	vOut.UV = float4(UV, 0, 0);

	if (doBlur)
	{
		// Compute blur (blur focus depth is z=0):
		float dist_factor = abs((world_pos.z - CameraZPos) / CameraZPos);
		// dist_factor examples: 1.0=the exact focus depth, 2.0=twice the focus depth, 0.5=half the focus depth
		float d = log2(dist_factor); //specular.b holds the blur flag (0 or 1) and effectivly disables blur on the sprite.
		float blur = sqrt(abs(d))*fFocusFactor;
		if (d<0.0f)
			blur *= fFocusRatio;
		vOut.UV.w = clamp(blur, 0.0, 5.0);
	}
	return vOut;
}

float4 FixedFunction3DNUVPS(VS_OUTPUT vertexIn) : COLOR0
{
	float4 texel = 0;
	if (doBlur) {
#if defined(ORIGO_MAC)
		texel = tex2Dbias(TextureSampler, vertexIn.UV.xy, vertexIn.UV.w);
#else
		texel = tex2Dbias(TextureSampler, vertexIn.UV);
#endif
	}
	else {
		texel = tex2D(TextureSampler, vertexIn.UV.xy);
	}
		
	float alpha = texel.a * textureFactor.a;
	float3 current = texel.rgb * textureFactor.rgb;
	float3  result = current +  float3(1, 1, 1) * (1 - current);
	return float4(current,   alpha);
 }



VS_OUTPUT FixedFunction3DAnaglyphVS(float4 screen_pos : POSITION, float2 textureUV : TEXCOORD0)
{
	VS_OUTPUT vOut;
	vOut.Position.xy = ((screen_pos.xy)/viewport.zw)*float2(2.0, -2.0)+float2(-1.0, 1.0);
	vOut.Position.zw = screen_pos.zw;
	vOut.UV = float4(textureUV.x, textureUV.y, 0, 0);
	vOut.Diffuse = float4(1,1,1,1);
	return vOut;
}

// red green
//	float4 lBase = float4( 1.0f, 0.0f, 0.0f ,0.0f); 
//	float4 rBase = float4( 0.0f, 1.0f, 1.0f ,0.0f); 
// yellow blue
float4 lBase = float4( 1.0f, 1.0f, 0.0f ,0.0f);
float4 rBase = float4( 0.0f, 0.0f, 1.0f ,0.0f); 
	
float4 FixedFunction3DAnaglyphPS(VS_OUTPUT vertexIn) : COLOR0
{
	
	//read left and right texture samples
	float4 rcolor = tex2D(RightEyeSampler, vertexIn.UV.xy);
	float4 lcolor = tex2D(LeftEyeSampler, vertexIn.UV.xy);
	
	// use this line to use a colorcode translation texture
//	return tex2D(ColorCodeSampler,float2(lcolor.r,rcolor.r));
	
	//find max value of colour for use as value
	float  r_max= max( max(rcolor.x,rcolor.y), rcolor.z);
	float  l_max= max( max(lcolor.x,lcolor.y), lcolor.z);

	//generate greyscale image
	float4 rgray=float4(r_max,r_max,r_max,r_max);
	float4 lgray=float4(l_max,l_max,l_max,l_max);

	float rcyan = dot( rcolor, rBase );
	float rred  = dot( rcolor, lBase );
	float lcyan = dot( lcolor, rBase );
	float lred  = dot( lcolor, lBase );

	float r_ratio  = pow( 1.0f - clamp( abs( rcyan -rred ), 0, 1),  1 );
	float l_ratio  = pow( 1.0f - clamp( abs( lcyan -lred ), 0, 1),  1 );


	rcolor = r_ratio * rcolor + (1.0f-r_ratio)*rgray;
	lcolor = l_ratio * lcolor + (1.0f-l_ratio)*lgray;

	return rcolor* rBase+ lcolor*lBase;
}
