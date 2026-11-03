float3 deformationPos1 = float3(0,0,0);
float3 deformationData1 = float3(0,0,0);
float deformationDistance1 = float(0);
float3 deformationPos2 = float3(0,0,0);
float3 deformationData2 = float3(0,0,0);
float deformationDistance2 = float(0);
float3 deformationPos3 = float3(0,0,0);
float3 deformationData3 = float3(0,0,0);
float deformationDistance3 = float(0);
float3 deformationPos4 = float3(0,0,0);
float3 deformationData4 = float3(0,0,0);
float deformationDistance4 = float(0);
float3 deformationPos5 = float3(0,0,0);
float3 deformationData5 = float3(0,0,0);
float deformationDistance5 = float(0);
float3 deformationPos6 = float3(0,0,0);
float3 deformationData6 = float3(0,0,0);
float deformationDistance6 = float(0);
float3 deformationPos7 = float3(0,0,0);
float3 deformationData7 = float3(0,0,0);
float deformationDistance7 = float(0);
float3 deformationPos8 = float3(0,0,0);
float3 deformationData8 = float3(0,0,0);
float deformationDistance8 = float(0);
float3 deformationPos9 = float3(0,0,0);
float3 deformationData9 = float3(0,0,0);
float deformationDistance9 = float(0);
float3 deformationPos10 = float3(0,0,0);
float3 deformationData10 = float3(0,0,0);
float deformationDistance10 = float(0);
float3 deformationPos11 = float3(0,0,0);
float3 deformationData11 = float3(0,0,0);
float deformationDistance11 = float(0);
float3 deformationPos12 = float3(0,0,0);
float3 deformationData12 = float3(0,0,0);
float deformationDistance12 = float(0);
float3 deformationPos13 = float3(0,0,0);
float3 deformationData13 = float3(0,0,0);
float deformationDistance13 = float(0);
float3 deformationPos14 = float3(0,0,0);
float3 deformationData14 = float3(0,0,0);
float deformationDistance14 = float(0);
float3 deformationPos15 = float3(0,0,0);
float3 deformationData15 = float3(0,0,0);
float deformationDistance15 = float(0);
float3 deformationPos16 = float3(0,0,0);
float3 deformationData16 = float3(0,0,0);
float deformationDistance16 = float(0);
float3 deformationPos17 = float3(0,0,0);
float3 deformationData17 = float3(0,0,0);
float deformationDistance17 = float(0);
float3 deformationPos18 = float3(0,0,0);
float3 deformationData18 = float3(0,0,0);
float deformationDistance18 = float(0);
float3 deformationPos19 = float3(0,0,0);
float3 deformationData19 = float3(0,0,0);
float deformationDistance19 = float(0);
float3 deformationPos20 = float3(0,0,0);
float3 deformationData20 = float3(0,0,0);
float deformationDistance20 = float(0);
float3 deformationPos21 = float3(0,0,0);
float3 deformationData21 = float3(0,0,0);
float deformationDistance21 = float(0);
float3 deformationPos22 = float3(0,0,0);
float3 deformationData22 = float3(0,0,0);
float deformationDistance22 = float(0);

#include "mta-helper.fx"

struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

float distance(float x1, float y1, float z1, float x2, float y2, float z2) 
{ 
    float d = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) + pow(z2 - z1, 2) * 1.0);
    return d;
} 

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    float dist1 = distance(deformationPos1.x, deformationPos1.y, deformationPos1.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist1 < deformationDistance1)
    {
        float mult = (deformationDistance1 - dist1);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData1.x * mult);
        VS.Position.y = VS.Position.y + (deformationData1.y * mult);
        VS.Position.z = VS.Position.z + (deformationData1.z * mult);
    }
    float dist2 = distance(deformationPos2.x, deformationPos2.y, deformationPos2.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist2 < deformationDistance2)
    {
        float mult = (deformationDistance2 - dist2);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData2.x * mult);
        VS.Position.y = VS.Position.y + (deformationData2.y * mult);
        VS.Position.z = VS.Position.z + (deformationData2.z * mult);
    }
    float dist3 = distance(deformationPos3.x, deformationPos3.y, deformationPos3.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist3 < deformationDistance3)
    {
        float mult = (deformationDistance3 - dist3);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData3.x * mult);
        VS.Position.y = VS.Position.y + (deformationData3.y * mult);
        VS.Position.z = VS.Position.z + (deformationData3.z * mult);
    }
    float dist4 = distance(deformationPos4.x, deformationPos4.y, deformationPos4.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist4 < deformationDistance4)
    {
        float mult = (deformationDistance4 - dist4);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData4.x * mult);
        VS.Position.y = VS.Position.y + (deformationData4.y * mult);
        VS.Position.z = VS.Position.z + (deformationData4.z * mult);
    }
    float dist5 = distance(deformationPos5.x, deformationPos5.y, deformationPos5.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist5 < deformationDistance5)
    {
        float mult = (deformationDistance5 - dist5);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData5.x * mult);
        VS.Position.y = VS.Position.y + (deformationData5.y * mult);
        VS.Position.z = VS.Position.z + (deformationData5.z * mult);
    }
    float dist6 = distance(deformationPos6.x, deformationPos6.y, deformationPos6.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist6 < deformationDistance6)
    {
        float mult = (deformationDistance6 - dist6);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData6.x * mult);
        VS.Position.y = VS.Position.y + (deformationData6.y * mult);
        VS.Position.z = VS.Position.z + (deformationData6.z * mult);
    }
    float dist7 = distance(deformationPos7.x, deformationPos7.y, deformationPos7.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist7 < deformationDistance7)
    {
        float mult = (deformationDistance7 - dist7);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData7.x * mult);
        VS.Position.y = VS.Position.y + (deformationData7.y * mult);
        VS.Position.z = VS.Position.z + (deformationData7.z * mult);
    }
    float dist8 = distance(deformationPos8.x, deformationPos8.y, deformationPos8.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist8 < deformationDistance8)
    {
        float mult = (deformationDistance8 - dist8);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData8.x * mult);
        VS.Position.y = VS.Position.y + (deformationData8.y * mult);
        VS.Position.z = VS.Position.z + (deformationData8.z * mult);
    }
    float dist9 = distance(deformationPos9.x, deformationPos9.y, deformationPos9.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist9 < deformationDistance9)
    {
        float mult = (deformationDistance9 - dist9);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData9.x * mult);
        VS.Position.y = VS.Position.y + (deformationData9.y * mult);
        VS.Position.z = VS.Position.z + (deformationData9.z * mult);
    }
    float dist10 = distance(deformationPos10.x, deformationPos10.y, deformationPos10.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist10 < deformationDistance10)
    {
        float mult = (deformationDistance10 - dist10);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData10.x * mult);
        VS.Position.y = VS.Position.y + (deformationData10.y * mult);
        VS.Position.z = VS.Position.z + (deformationData10.z * mult);
    }
    float dist11 = distance(deformationPos11.x, deformationPos11.y, deformationPos11.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist11 < deformationDistance11)
    {
        float mult = (deformationDistance11 - dist11);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData11.x * mult);
        VS.Position.y = VS.Position.y + (deformationData11.y * mult);
        VS.Position.z = VS.Position.z + (deformationData11.z * mult);
    }
    float dist12 = distance(deformationPos12.x, deformationPos12.y, deformationPos12.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist12 < deformationDistance12)
    {
        float mult = (deformationDistance12 - dist12);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData12.x * mult);
        VS.Position.y = VS.Position.y + (deformationData12.y * mult);
        VS.Position.z = VS.Position.z + (deformationData12.z * mult);
    }
    float dist13 = distance(deformationPos13.x, deformationPos13.y, deformationPos13.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist13 < deformationDistance13)
    {
        float mult = (deformationDistance13 - dist13);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData13.x * mult);
        VS.Position.y = VS.Position.y + (deformationData13.y * mult);
        VS.Position.z = VS.Position.z + (deformationData13.z * mult);
    }
    float dist14 = distance(deformationPos14.x, deformationPos14.y, deformationPos14.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist14 < deformationDistance14)
    {
        float mult = (deformationDistance14 - dist14);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData14.x * mult);
        VS.Position.y = VS.Position.y + (deformationData14.y * mult);
        VS.Position.z = VS.Position.z + (deformationData14.z * mult);
    }
    float dist15 = distance(deformationPos15.x, deformationPos15.y, deformationPos15.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist15 < deformationDistance15)
    {
        float mult = (deformationDistance15 - dist15);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData15.x * mult);
        VS.Position.y = VS.Position.y + (deformationData15.y * mult);
        VS.Position.z = VS.Position.z + (deformationData15.z * mult);
    }
    float dist16 = distance(deformationPos16.x, deformationPos16.y, deformationPos16.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist16 < deformationDistance16)
    {
        float mult = (deformationDistance16 - dist16);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData16.x * mult);
        VS.Position.y = VS.Position.y + (deformationData16.y * mult);
        VS.Position.z = VS.Position.z + (deformationData16.z * mult);
    }
    float dist17 = distance(deformationPos17.x, deformationPos17.y, deformationPos17.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist17 < deformationDistance17)
    {
        float mult = (deformationDistance17 - dist17);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData17.x * mult);
        VS.Position.y = VS.Position.y + (deformationData17.y * mult);
        VS.Position.z = VS.Position.z + (deformationData17.z * mult);
    }
    float dist18 = distance(deformationPos18.x, deformationPos18.y, deformationPos18.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist18 < deformationDistance18)
    {
        float mult = (deformationDistance18 - dist18);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData18.x * mult);
        VS.Position.y = VS.Position.y + (deformationData18.y * mult);
        VS.Position.z = VS.Position.z + (deformationData18.z * mult);
    }
    float dist19 = distance(deformationPos19.x, deformationPos19.y, deformationPos19.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist19 < deformationDistance19)
    {
        float mult = (deformationDistance19 - dist19);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData19.x * mult);
        VS.Position.y = VS.Position.y + (deformationData19.y * mult);
        VS.Position.z = VS.Position.z + (deformationData19.z * mult);
    }
    float dist20 = distance(deformationPos20.x, deformationPos20.y, deformationPos20.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist20 < deformationDistance20)
    {
        float mult = (deformationDistance20 - dist20);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData20.x * mult);
        VS.Position.y = VS.Position.y + (deformationData20.y * mult);
        VS.Position.z = VS.Position.z + (deformationData20.z * mult);
    }
    float dist21 = distance(deformationPos21.x, deformationPos21.y, deformationPos21.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist21 < deformationDistance21)
    {
        float mult = (deformationDistance21 - dist21);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData21.x * mult);
        VS.Position.y = VS.Position.y + (deformationData21.y * mult);
        VS.Position.z = VS.Position.z + (deformationData21.z * mult);
    }
    float dist22 = distance(deformationPos22.x, deformationPos22.y, deformationPos22.z, VS.Position.x, VS.Position.y, VS.Position.z);
    if(dist22 < deformationDistance22)
    {
        float mult = (deformationDistance22 - dist22);
        if(mult < 0) { float mult = 0; }
        VS.Position.x = VS.Position.x + (deformationData22.x * mult);
        VS.Position.y = VS.Position.y + (deformationData22.y * mult);
        VS.Position.z = VS.Position.z + (deformationData22.z * mult);
    }

    PS.Position = MTACalcScreenPosition ( VS.Position );
    PS.TexCoord = VS.TexCoord;
    float3 WorldNormal = MTACalcWorldNormal( VS.Normal );
    PS.Diffuse = MTACalcGTAVehicleDiffuse( WorldNormal, VS.Diffuse );

    return PS;
}


technique tec0
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
    }
}