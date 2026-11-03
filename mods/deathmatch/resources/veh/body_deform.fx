#include "mta-helper.fx"

float data1[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data2[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data3[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data4[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data5[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data6[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data7[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data8[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data9[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data10[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data11[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
float data12[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

float3 saturationZ 	= float3(0,0,0);
float3 startFrame 	= float3(0,0,0);
float ymin = -999;
float3 leftCorner 	= float3(0,0,0);
float step = 111;
float3 kickPos 		= float3(0,0,0);






sampler MainSampler = sampler_state
{
    Texture = <gTexture0>;
};

struct VertexShaderInput
{
    float3 Position : POSITION0;
	float4 Color : COLOR0;
    float3 Normal : NORMAL0;
	float2 TexCoord : TEXCOORD0;
};
 
struct VertexShaderOutput
{
    float4 Position : POSITION0;
	float4 Color : COLOR0;
	float2 TexCoord : TEXCOORD0;
	float3 worldNormal : TEXCOORD2;
};

float3 newLocation(float3 vrx1)
{
	if (data1[0] == 0 || data12[0] == 0)
		return float3(0,0,0);
		
	int plane1 = floor( (vrx1.y - ymin) / step );
	int plane2 = plane1 + 1;
	
	int ix1 = plane1*3;
	int iy1 = ix1+1;
	int iz1 = ix1+2;
	int ix2 = plane2*3;
	int iy2 = ix2+1;
	int iz2 = ix2+2;
	
	float3 bckFactor = float3(0.2, 0.2, 0.2);
	float3 bckIntensity = float3(4, 8, 12);
	
	float Lz = (vrx1.y - data4[iy1]) / (data4[iy2] - data4[iy1]);
	
	float3 uDataUM1 = float3(data4[ix1], data4[iy1], data4[iz1]);
	float3 uDataUM2 = float3(data4[ix2], data4[iy2], data4[iz2]);
	float3 medUM = uDataUM1 + (uDataUM2 - uDataUM1) * Lz;
	
	float3 uDataDM1 = float3(data10[ix1], data10[iy1], data10[iz1]);
	float3 uDataDM2 = float3(data10[ix2], data10[iy2], data10[iz2]);
	float3 medDM = uDataDM1 + (uDataDM2 - uDataDM1) * Lz;
	
	float3 dDataUM1 = float3(data9[ix1], data9[iy1], data9[iz1]);
	float3 dDataUM2 = float3(data9[ix2], data9[iy2], data9[iz2]);
	float3 medUMdef = dDataUM1 + (dDataUM2 - dDataUM1) * Lz;
	
	float3 dDataDM1 = float3(data11[ix1], data11[iy1], data11[iz1]);
	float3 dDataDM2 = float3(data11[ix2], data11[iy2], data11[iz2]);
	float3 medDMdef = dDataDM1 + (dDataDM2 - dDataDM1) * Lz;
	if (vrx1.x >= 0.001)
	{
		float3 uDataUR1 = float3(data5[ix1], data5[iy1], data5[iz1]);
		float3 uDataUR2 = float3(data5[ix2], data5[iy2], data5[iz2]);
		float3 medUR = uDataUR1 + (uDataUR2 - uDataUR1) * Lz;
		
		float3 uDataDR1 = float3(data8[ix1], data8[iy1], data8[iz1]);
		float3 uDataDR2 = float3(data8[ix2], data8[iy2], data8[iz2]);
		float3 medDR = uDataDR1 + (uDataDR2 - uDataDR1) * Lz;
		float nX = vrx1.x / medUR.x;
		float nZ = (vrx1.z - medDR.z) / (medUR.z - medDR.z);
		
		float3 dDataUR1 = float3(data2[ix1], data2[iy1], data2[iz1]);
		float3 dDataUR2 = float3(data2[ix2], data2[iy2], data2[iz2]);
		
		float3 dDataDR1 = float3(data6[ix1], data6[iy1], data6[iz1]);
		float3 dDataDR2 = float3(data6[ix2], data6[iy2], data6[iz2]);
		
		float3 medURdef = dDataUR1 + (dDataUR2 - dDataUR1) * Lz;
		float3 medDRdef = dDataDR1 + (dDataDR2 - dDataDR1) * Lz;
		
		float3 fullUp = medUMdef + (medURdef - medUMdef) * nX;
		float3 fullDown = medDMdef + (medDRdef - medDMdef) * nX;
		float3 fullPos = fullDown + (fullUp - fullDown) * nZ;
		
		
		float3 uFullUp1 = uDataUM1 + (uDataUR1 - uDataUM1) * nX;
		float3 uFullDown1 = uDataDM1 + (uDataDR1 - uDataDM1) * nX;
		float3 uFullPos1 = uFullDown1 + (uFullUp1 - uFullDown1) * nZ;
		
		float3 uFullUp2 = uDataUM2 + (uDataUR2 - uDataUM2) * nX;
		float3 uFullDown2 = uDataDM2 + (uDataDR2 - uDataDM2) * nX;
		float3 uFullPos2 = uFullDown2 + (uFullUp2 - uFullDown2) * nZ;
		
		float3 uYdir = uFullPos2 - uFullPos1;
		
		float3 dFullUp1 = dDataUM1 + (dDataUR1 - dDataUM1) * nX;
		float3 dFullDown1 = dDataDM1 + (dDataDR1 - dDataDM1) * nX;
		float3 dFullPos1 = dFullDown1 + (dFullUp1 - dFullDown1) * nZ;
		
		float3 dFullUp2 = dDataUM2 + (dDataUR2 - dDataUM2) * nX;
		float3 dFullDown2 = dDataDM2 + (dDataDR2 - dDataDM2) * nX;
		float3 dFullPos2 = dFullDown2 + (dFullUp2 - dFullDown2) * nZ;
		
		float3 dYdir = dFullPos2 - dFullPos1;
		
		float dpYdir = (length(uYdir) - length(dYdir)) / length(uYdir);
		float bckY = dpYdir * bckFactor.y * sin(Lz * PI * bckIntensity.y);
		float3 bckDirY = normalize(fullPos - (medUMdef + medDMdef) / 2);
		
		float3 uFullMiddle = medDM + (medUM - medDM) * nZ;
		float3 uFullSide = medDR + (medUR - medDR) * nZ;
		float3 uFullX = uFullSide - uFullMiddle;
		
		float3 dFullMiddle = medDMdef + (medUMdef - medDMdef) * nZ;
		float3 dFullSide = medDRdef + (medURdef - medDRdef) * nZ;
		float3 dFullX = dFullSide - dFullMiddle;
		
		float dpX = (length(uFullX) - length(dFullX)) / length(uFullX);
		float bckX = dpX * bckFactor.x * sin(nX * PI * bckIntensity.x);
		float3 bckDirX = normalize(fullUp - fullDown);
		
		float3 undFullUp = medUM + (medUR - medUM) * nX;
		float3 undFullDown = medDM + (medDR - medDM) * nX;
		float3 undFullZd = undFullUp - undFullDown;
		float3 defFullZd = fullUp - fullDown;
		
		float dpZ = (length(undFullZd) - length(defFullZd)) / length(undFullZd);
		float bckZ = dpZ * bckFactor.z * sin(nZ * PI * bckIntensity.z);
		float3 bckDirZ = normalize(dFullX);
		
		return fullPos - vrx1 + bckDirY * bckY + bckDirX * bckX + bckDirZ * bckZ;
	}
	else
	{
		float3 uDataUL1 = float3(data1[ix1], data1[iy1], data1[iz1]);
		float3 uDataUL2 = float3(data1[ix2], data1[iy2], data1[iz2]);
		float3 medUL = uDataUL1 + (uDataUL2 - uDataUL1) * Lz;
		
		float3 uDataDL1 = float3(data3[ix1], data3[iy1], data3[iz1]);
		float3 uDataDL2 = float3(data3[ix2], data3[iy2], data3[iz2]);
		float3 medDL = uDataDL1 + (uDataDL2 - uDataDL1) * Lz;
		float nX = vrx1.x / medUL.x;
		float nZ = (vrx1.z - medDL.z) / (medUL.z - medDL.z);
		
		float3 dDataUL1 = float3(data12[ix1], data12[iy1], data12[iz1]);
		float3 dDataUL2 = float3(data12[ix2], data12[iy2], data12[iz2]);
		
		float3 dDataDL1 = float3(data7[ix1], data7[iy1], data7[iz1]);
		float3 dDataDL2 = float3(data7[ix2], data7[iy2], data7[iz2]);
		
		float3 medULdef = dDataUL1 + (dDataUL2 - dDataUL1) * Lz;
		float3 medDLdef = dDataDL1 + (dDataDL2 - dDataDL1) * Lz;
		
		float3 fullUp = medUMdef + (medULdef - medUMdef) * nX;
		float3 fullDown = medDMdef + (medDLdef - medDMdef) * nX;
		float3 fullPos = fullDown + (fullUp - fullDown) * nZ;
		
		
		float3 uFullUp1 = uDataUM1 + (uDataUL1 - uDataUM1) * nX;
		float3 uFullDown1 = uDataDM1 + (uDataDL1 - uDataDM1) * nX;
		float3 uFullPos1 = uFullDown1 + (uFullUp1 - uFullDown1) * nZ;
		
		float3 uFullUp2 = uDataUM2 + (uDataUL2 - uDataUM2) * nX;
		float3 uFullDown2 = uDataDM2 + (uDataDL2 - uDataDM2) * nX;
		float3 uFullPos2 = uFullDown2 + (uFullUp2 - uFullDown2) * nZ;
		
		float3 uYdir = uFullPos2 - uFullPos1;
		
		float3 dFullUp1 = dDataUM1 + (dDataUL1 - dDataUM1) * nX;
		float3 dFullDown1 = dDataDM1 + (dDataDL1 - dDataDM1) * nX;
		float3 dFullPos1 = dFullDown1 + (dFullUp1 - dFullDown1) * nZ;
		
		float3 dFullUp2 = dDataUM2 + (dDataUL2 - dDataUM2) * nX;
		float3 dFullDown2 = dDataDM2 + (dDataDL2 - dDataDM2) * nX;
		float3 dFullPos2 = dFullDown2 + (dFullUp2 - dFullDown2) * nZ;
		
		float3 dYdir = dFullPos2 - dFullPos1;
		
		float dpYdir = (length(uYdir) - length(dYdir)) / length(uYdir);
		float bckY = dpYdir * bckFactor.y * sin(Lz * PI * bckIntensity.y);
		float3 bckDirY = normalize(fullPos - (medUMdef + medDMdef) / 2);
		
		float3 uFullMiddle = medDM + (medUM - medDM) * nZ;
		float3 uFullSide = medDL + (medUL - medDL) * nZ;
		float3 uFullX = uFullSide - uFullMiddle;
		
		float3 dFullMiddle = medDMdef + (medUMdef - medDMdef) * nZ;
		float3 dFullSide = medDLdef + (medULdef - medDLdef) * nZ;
		float3 dFullX = dFullSide - dFullMiddle;
		
		float dpX = (length(uFullX) - length(dFullX)) / length(uFullX);
		float bckX = dpX * bckFactor.x * sin(nX * PI * bckIntensity.x);
		float3 bckDirX = normalize(fullUp - fullDown);
		
		float3 undFullUp = medUM + (medUL - medUM) * nX;
		float3 undFullDown = medDM + (medDL - medDM) * nX;
		float3 undFullZd = undFullUp - undFullDown;
		float3 defFullZd = fullUp - fullDown;
		
		float dpZ = (length(undFullZd) - length(defFullZd)) / length(undFullZd);
		float bckZ = dpZ * bckFactor.z * sin(nZ * PI * bckIntensity.z);
		float3 bckDirZ = normalize(dFullX);
		
		return fullPos - vrx1 + bckDirY * bckY + bckDirX * bckX + bckDirZ * bckZ;
	}
}

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
	float3x3 kFzChain = float3x3(saturationZ, leftCorner, kickPos);
	float3x3 mrtNz = transpose(kFzChain);
	float3x3 modelToWorldMatrix = (float3x3)gWorld;
	float3x3 worldToModelMatrix = transpose(gWorld);
	float3 modelGlobalPos = gWorld[3].xyz;
	
	MTAFixUpNormal(input.Normal);
	
	float3 vectorPos = mul(input.Position, modelToWorldMatrix) + modelGlobalPos;
	float3 vrx1 = mul(vectorPos - startFrame, mrtNz);
	float3 location1 = newLocation(vrx1);
	float3 vertexLocalVector1 = vrx1 + location1;
	float3 vectorPos1 = startFrame + mul(vertexLocalVector1, kFzChain);
	float3 resultVertexPos = mul(vectorPos1 - gWorld[3].xyz, transpose((float3x3)gWorld));
	
	output.Position = MTACalcScreenPosition(resultVertexPos);
	//output.Position = MTACalcScreenPosition(input.Position);
	output.Color = input.Color;
	output.TexCoord = input.TexCoord;
	output.worldNormal = mul(input.Normal, modelToWorldMatrix);
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float3 lightDirection = getLightDirection();
	float4 carColor = shadeColor(input.worldNormal, lightDirection);
	float4 mainColor = tex2D(MainSampler, input.TexCoord);
	float4 specularColor = MTACalculateSpecular(gCameraDirection, lightDirection, input.worldNormal, 64);
	float4 finalColor = saturate(float4(mainColor.rgb * carColor.rgb * 0.8 + specularColor.rgb * 0.4, carColor.a));
	return finalColor;
}

technique CarShader
{
    pass Pass0
    {
		AlphaBlendEnable = true;
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
