//
//  MetalViewCoordinator.swift
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

import Foundation
import SwiftUI
import MetalKit
import Vision




class Coordinator : NSObject, MTKViewDelegate {
    var parent: MetalView
    var device: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    
    var verticesSegments = [[VertexIn]]()
    

    
    func update(textObservations:[VNRecognizedTextObservation]) {
        verticesSegments = (textObservations as [VNRectangleObservation]).toCornerMarkers()
    }
    
    init(_ parent: MetalView) {
        self.parent = parent
        if let device = MTLCreateSystemDefaultDevice() {
            self.device = device
        }
        self.metalCommandQueue = device.makeCommandQueue()!
        super.init()
    }
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        // Get the current drawable and command buffer
        guard let drawable = view.currentDrawable,
              let commandBuffer = metalCommandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Create a render command encoder
        let renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        // Set the vertex buffer
        let flatVertices = verticesSegments.flatMap { $0 }
        if flatVertices.count > 0 {
            let vertexBuffer = device.makeBuffer(bytes: flatVertices, length: MemoryLayout<VertexIn>.stride * flatVertices.count, options: [])
            renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        }
        
        // Set the shader functions
        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "myFragmentShader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        let renderPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)

        // Set up the time constant for the shader
        let currentTime = CACurrentMediaTime()
        var time = Float(currentTime)
        let timeBuffer = device.makeBuffer(bytes: &time, length: MemoryLayout<Float>.size, options: [])
        renderCommandEncoder.setFragmentBuffer(timeBuffer, offset: 0, index: 0)
        
        // Draw the vertices
        if verticesSegments.count > 0 {
            for i in 0..<verticesSegments.count {
                let verticesInSegment = verticesSegments[i]
                renderCommandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: i*verticesInSegment.count, vertexCount: verticesInSegment.count)
            }
        }
        
        // Finish encoding and commit the command buffer
        renderCommandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }


}
