
#include <metal_stdlib>
using namespace metal;

#include "ShaderDefinitions.h"


struct VertexOut {
    float4 color;
    float4 pos [[position]];
};

vertex VertexOut vertexShader(const device Vertex *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]])
{
    Vertex in = vertexArray[vid];
    
    VertexOut out;
    out.color = in.color;
    out.pos = float4(in.pos.x, in.pos.y, 0, 1);
    
    return out;
}

fragment float4 fragmentBrightnessShader(VertexOut interpolated [[stage_in]], constant FragmentUniforms &uniforms [[buffer(0)]])
{
    return float4(uniforms.brightness * interpolated.color.rgb, interpolated.color.a);
}




float hash(float2 p) {
    float h = dot(p, float2(127.1, 311.7));
    return fract(sin(h) * 43758.5453123);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);

    float a = hash(i);
    float b = hash(i + float2(1.0, 0.0));
    float c = hash(i + float2(0.0, 1.0));
    float d = hash(i + float2(1.0, 1.0));

    float u = dot(f, f) * (3.0 - 2.0 * dot(f, f));
    return mix(a, b, u) + (c - a) * f.y * (1.0 - f.x) + (d - b) * f.x * f.y;
}


fragment float4 fragmentPrettyShader(VertexOut fragment_in [[stage_in]], constant FragmentUniforms &uniforms [[buffer(0)]]) {
    float2 uv = fragment_in.pos.xy * 0.5 + 0.5;
    float2 p = uv * float2(20.0, 20.0);

    float n = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 4; i++) {
        n += abs(1.0 - 2.0 * noise(p * scale)) / scale;
        scale *= 2.0;
    }

    float3 color1 = float3(1.0, 0.5, 0.0);
    float3 color2 = float3(0.0, 0.3, 1.0);
    float3 color = mix(color1, color2, n);

    return float4(color, 1.0);
}


fragment float4 fragmentRedShader(VertexOut vertexOut [[stage_in]]) {
    return float4(1.0, 0.0, 0.0, 1.0);
}
