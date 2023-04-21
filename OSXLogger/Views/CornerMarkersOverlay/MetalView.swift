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

    func makeCoordinator() -> Renderer {
        Renderer()
    }

    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
        let mtkView = MTKView()
//        mtkView.preferredFramesPerSecond = 60
//        mtkView.enableSetNeedsDisplay = true
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
//        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
//        mtkView.drawableSize = mtkView.frame.size
//        mtkView.enableSetNeedsDisplay = true
//        mtkView.isPaused = true
        context.coordinator.attachTo(mtkView: mtkView)

        mtkView.delegate = context.coordinator
        mtkView.layer?.isOpaque = false

        return mtkView
    }

    func updateNSView(_: MTKView, context: NSViewRepresentableContext<MetalView>) {
        context.coordinator.update(textObservations: screenAnalyzer.text)
//        nsView.delegate?.draw(in: nsView)
    }
}
