//
//  Shaders.metal
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

#include <metal_stdlib>
using namespace metal;




// Metal fragment shader function
fragment float4 myFragmentShader()
{
    return float4(0.5, 0.1, 0.2, 1.0); // Return red color
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

    out.position = float4(vertices[vid].position, 0.0, 1.0);


    return out;
}
