//
//  Renderer.swift
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

import Foundation

import Foundation
import Metal
import MetalKit
import Vision

class Renderer : NSObject, MTKViewDelegate {
    
    var verticesSegments = [[Vertex]]()
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    
    var fragmentUniformsBuffer: MTLBuffer!
    
    // This keeps track of the system time of the last render
    var lastRenderTime: CFTimeInterval? = nil
    // This is the current time in our app, starting at 0, in units of seconds
    var currentTime: Double = 0
    
    let gpuLock = DispatchSemaphore(value: 1)
    
    override init() {
        
    }

    func attachTo(mtkView: MTKView) {
        device = mtkView.device!
        
        commandQueue = device.makeCommandQueue()!
        
        // Create the Render Pipeline
        do {
            pipelineState = try Renderer.buildRenderPipelineWith(device: device, metalKitView: mtkView)
        } catch {
            print("Unable to compile render pipeline state: \(error)")
            return
        }
        
        // Create our uniform buffer, and fill it with an initial brightness of 1.0
        var initialFragmentUniforms = FragmentUniforms(brightness: 1.0)
        fragmentUniformsBuffer = device.makeBuffer(bytes: &initialFragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride, options: [])!
    }
    
    // Create our custom rendering pipeline, which loads shaders using `device`, and outputs to the format of `metalKitView`
    class func buildRenderPipelineWith(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        // Create a new pipeline descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        
        // Setup the shaders in the pipeline
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        // Setup the output pixel format to match the pixel format of the metal kit view
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        // Compile the configured pipeline descriptor to a pipeline state object
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }
    
    func update(dt: CFTimeInterval) {
        let ptr = fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.5 * cos(currentTime) + 0.5)
        
        currentTime += dt
    }
    
    
    func draw(in view: MTKView) {
        
        gpuLock.wait()
        
        // Compute dt
        let systemTime = CACurrentMediaTime()
        let timeDifference = (lastRenderTime == nil) ? 0 : (systemTime - lastRenderTime!)
        lastRenderTime = systemTime
        
        update(dt: timeDifference)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
//        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
       let flatVertices = verticesSegments.flatMap { $0 }
       if flatVertices.count > 0 {
           let vertexBuffer = device.makeBuffer(bytes: flatVertices, length: MemoryLayout<Vertex>.stride * flatVertices.count, options: [])
           renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
       }

        renderEncoder.setFragmentBuffer(fragmentUniformsBuffer, offset: 0, index: 0)
        
        
        // Draw the vertices
        if verticesSegments.count > 0 {
            for i in 0..<verticesSegments.count {
                let verticesInSegment = verticesSegments[i]
                renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: i*verticesInSegment.count, vertexCount: verticesInSegment.count)
            }
        }
        
        renderEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        
        commandBuffer.addCompletedHandler { _ in
            self.gpuLock.signal()
        }
        
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
    
    
    func update(textObservations:[VNRecognizedTextObservation]) {
            verticesSegments = (textObservations as [VNRectangleObservation]).toCornerMarkers()
    }
}
//



//
