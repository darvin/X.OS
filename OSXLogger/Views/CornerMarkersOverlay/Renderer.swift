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

class Renderer: NSObject, MTKViewDelegate {
    var cornerMarkerVertices = [[Vertex]]()

    var emptySpaceVertices = NormalizedRect.randomNonOverlappingRects(size: 3).toVertices()

    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var cornerMarkersPipelineState: MTLRenderPipelineState!
    var prettyEmptySpacePipelineState: MTLRenderPipelineState!

    var fragmentUniformsBuffer: MTLBuffer!

    var lastRenderTime: CFTimeInterval? = nil

    var currentTime: Double = 0

    let gpuLock = DispatchSemaphore(value: 1)

    override init() {}

    func attachTo(mtkView: MTKView) {
        device = mtkView.device!

        commandQueue = device.makeCommandQueue()!

        do {
            cornerMarkersPipelineState = try Renderer.buildCornerMarkersPipeline(device: device, metalKitView: mtkView)
            prettyEmptySpacePipelineState = try Renderer.buildPrettyEmptySpacePipeline(device: device, metalKitView: mtkView)
        } catch {
            print("Unable to compile render pipeline state: \(error)")
            return
        }

        var initialFragmentUniforms = FragmentUniforms(brightness: 1.0, time: 0.0)
        fragmentUniformsBuffer = device.makeBuffer(bytes: &initialFragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride, options: [])!
    }

    class func buildCornerMarkersPipeline(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentBrightnessShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }

    class func buildPrettyEmptySpacePipeline(device: MTLDevice, metalKitView: MTKView) throws -> MTLRenderPipelineState {
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentPrettyShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }

    func update(dt: CFTimeInterval) {
        let ptr = fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.5 * cos(currentTime) + 0.5)
        ptr.pointee.time = Float(currentTime)
        currentTime += dt
    }

    fileprivate func renderVertices(with renderEncoder: MTLRenderCommandEncoder, vertices: [[Vertex]]) {
        let flatVertices = vertices.flatMap { $0 }
        if flatVertices.count > 0 {
            let vertexBuffer = device.makeBuffer(bytes: flatVertices, length: MemoryLayout<Vertex>.stride * flatVertices.count, options: [])
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        }

        renderEncoder.setFragmentBuffer(fragmentUniformsBuffer, offset: 0, index: 0)

        // Draw the vertices
        if vertices.count > 0 {
            for i in 0 ..< vertices.count {
                let verticesInSegment = vertices[i]
                renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: i * verticesInSegment.count, vertexCount: verticesInSegment.count)
            }
        }
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

        renderEncoder.setRenderPipelineState(cornerMarkersPipelineState)

        renderVertices(with: renderEncoder, vertices: cornerMarkerVertices)

//        renderEncoder.setRenderPipelineState(prettyEmptySpacePipelineState)
//
//        renderVertices(with: renderEncoder, vertices: emptySpaceVertices)

        renderEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)

        commandBuffer.addCompletedHandler { _ in
            self.gpuLock.signal()
        }

        commandBuffer.commit()
    }

    func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {}

    func update(textObservations: [VNRecognizedTextObservation]) {
        cornerMarkerVertices = (textObservations as [VNRectangleObservation]).toCornerMarkers()
    }
}
