//
//  Shaders.metal
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

#include <metal_stdlib>
using namespace metal;




struct VertexOut {
    float4 position [[position]];
};

// Uniforms
struct Uniforms {
    float time;
};

// Metal fragment shader function
fragment float4 myFragmentShader(
    VertexOut vertexOut [[stage_in]],
    constant Uniforms& uniforms [[buffer(0)]]
) {
    // Calculate a value between 0 and 1 that oscillates over time
    float oscillation = 0.5 + 0.5 * sin(uniforms.time);

    // Interpolate between green and pink using the oscillation value
    float4 green = float4(0.0, 1.0, 0.0, 1.0);
    float4 pink = float4(1.0, 0.0, 1.0, 1.0);
    float4 color = mix(green, pink, oscillation);

    // Return the interpolated color
    return color;
}




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
