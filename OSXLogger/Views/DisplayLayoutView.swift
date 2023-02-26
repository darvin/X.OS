//
//  ScreenLayoutView.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import SwiftUI
import ScreenCaptureKit





struct DisplayLayoutView: View {
    static private func frame(in bounds: CGRect, windowFrame: CGRect, displayFrame: CGRect) -> CGRect {
        let scaleX = bounds.width / displayFrame.width
        let scaleY = bounds.height / displayFrame.height
        let offsetX = (bounds.origin.x - displayFrame.origin.x) * scaleX
        let offsetY = (bounds.origin.y - displayFrame.origin.y) * scaleY
        
        let windowX = (windowFrame.origin.x - displayFrame.origin.x) * scaleX + offsetX
        let windowY = (windowFrame.origin.y - displayFrame.origin.y) * scaleY + offsetY
        let windowWidth = windowFrame.width * scaleX
        let windowHeight = windowFrame.height * scaleY
        
        let result = CGRect(x: windowX, y: windowY, width: windowWidth, height: windowHeight)
        return result
    }

    
    var windows: [SCWindow]
    var display: SCDisplay
    
    var body: some View {
        GeometryReader { geometry in
            let bounds = geometry.frame(in: CoordinateSpace.local)
            ZStack {
                ForEach(windows, id: \.self) { window in
                    
                    let frame = Self.frame(in: bounds, windowFrame: window.frame, displayFrame: display.frame)
                    
                    WindowLayoutView(window: window, inDisplay: display)
                        .frame(width: frame.width, height: frame.height)
                        .position(x: frame.origin.x + (frame.width / 2), y: frame.origin.y + (frame.height / 2))
                }
            }
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(CGSize(width: display.width, height: display.height), contentMode: .fit)
        .background(Color.green)

        
    }
}

//struct ScreenLayoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayLayoutView()
//    }
//}
