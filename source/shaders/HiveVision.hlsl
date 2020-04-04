#include <renderer/RenderSetup.hlsl>

struct VS_INPUT
{
    float3 ssPosition   : POSITION;
    float2 texCoord     : TEXCOORD0;
};

struct VS_OUTPUT
{
    float2 texCoord     : TEXCOORD0;
    float4 ssPosition   : SV_POSITION;
};

struct PS_INPUT
{
    float2 texCoord     : TEXCOORD0;
};

sampler2D     inputTexture;
sampler2D     inputTexture1;
sampler2D     inputTexture2;
sampler2D     noiseTexture;
sampler2D     depthTexture;
    
/**
 * Vertex shader.
 */  
VS_OUTPUT SFXBasicVS(VS_INPUT input)
{

    VS_OUTPUT output;

    output.ssPosition = float4(input.ssPosition, 1);
    output.texCoord   = input.texCoord + texelCenter;

    return output;

}

float4 DownSamplePS(PS_INPUT input) : COLOR0
{
    return tex2D( inputTexture, input.texCoord );
}

float4 FinalCompositePS(PS_INPUT input) : COLOR0
{

    float4 result = tex2D(inputTexture, input.texCoord);
    float2 depth = tex2D(depthTexture, input.texCoord).rg;

    // Blend in the outlines of objects visible through the walls.
    float4 glow = tex2D(inputTexture1,  input.texCoord);
    if (glow.a > 0)
    {
        float4 mask = tex2D( inputTexture2, input.texCoord);
        float fadeout=clamp(pow(2.0,-depth.r*.55), 0.3, 1);

        float4 smoke = tex2D(noiseTexture, input.texCoord * 10 + time * 0.12);
        
         float opacity = 1 - mask.a;
        result += glow * smoke * opacity * 3 * fadeout;
    }

    return result;

}
