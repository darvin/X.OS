//
//  MetalView.swift
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

import Foundation
import SwiftUI

import MetalKit
struct MetalView: NSViewRepresentable {
    
    @EnvironmentObject var screenAnalyzer: ScreenAnalyzer

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.drawableSize = mtkView.frame.size
        mtkView.enableSetNeedsDisplay = true
        mtkView.layer?.isOpaque = false
        mtkView.isPaused = true
        return mtkView
    }
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MetalView>) {
        context.coordinator.update(textObservations:screenAnalyzer.text)
        nsView.delegate?.draw(in: nsView)

    }
}
