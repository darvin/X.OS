//
//  Shaders.metal
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

#include <metal_stdlib>
using namespace metal;



// Metal vertex shader function
vertex float4 myVertexShader(const device packed_float3* vertex_array [[buffer(0)]],
                             unsigned int vid [[vertex_id]])
{
    float4 v = float4(vertex_array[vid], 1.0);
    return v;
}

// Metal fragment shader function
fragment float4 myFragmentShader()
{
    return float4(1.0, 0.0, 0.0, 1.0); // Return red color
}


struct VertexOut {
    float4 position [[position]];
};


struct VertexIn {
    float2 position;
};


vertex VertexOut vertex_main(constant VertexIn *vertices [[buffer(0)]],
                             unsigned int vid [[vertex_id]])
{
    VertexOut out;
    out.position = float4(vertices[vid].position, 1.0);
    return out;
}
