//
//  VisionOverlayView.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import Foundation

import Foundation

import SwiftUI
import Vision

func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
    return VNImagePointForNormalizedPoint(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}

func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
    return VNImageRectForNormalizedRect(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}

struct VisionOverlayView: View {
    @ObservedObject var screenAnalyzer: ScreenAnalyzer

    func positionMarkerView(normalizedRect: CGRect, in geometry: GeometryProxy, content: () -> some View) -> some View {
        let rect = DenormalizedRect(normalizedRect, forSize: geometry.size)

        return content()
            .frame(width: rect.width, height: rect.height)
            // Changed to position
            // Adjusting for center vs leading origin
            .position(x: rect.origin.x + rect.width / 2, y: rect.origin.y + rect.height / 2)
    }

    func positionMarkerView(normalizedPoint: VNPoint, in geometry: GeometryProxy, content: () -> some View) -> some View {
        let point = DenormalizedPoint(CGPoint(x: normalizedPoint.x, y: normalizedPoint.y), forSize: geometry.size)

        return content()
            // Changed to position
            // Adjusting for center vs leading origin
            .position(x: point.x, y: point.y)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                /*
                 ForEach(screenAnalyzer.objects, id: \.uuid) { object in
                     positionMarkerView(normalizedRect: object.boundingBox, in: geometry) {
                         VisionMarkerView(type: .redBold)
                     }
                 }*/

                ForEach(screenAnalyzer.text, id: \.self) { txt in
                    positionMarkerView(normalizedRect: txt.boundingBox, in: geometry) {
                        VisionMarkerView(type: .greenThin)
                    }
                }

                /*

                 ForEach(screenAnalyzer.hands, id: \.uuid) { hand in
                     ForEach(hand.availableJointNames, id: \.self) { joint in
                         if let point = try? hand.recognizedPoint(joint) {
                             positionMarkerView(normalizedPoint: point, in: geometry) {
                                 VisionMarkerView(type: .yellowCicle)
                                     .frame(width: 5, height: 5)
                             }
                         }
                     }
                 }

                 ForEach(screenAnalyzer.humanBodyPoses, id: \.uuid) { pose in
                     ForEach(pose.availableJointNames, id: \.self) { joint in
                         if let point = try? pose.recognizedPoint(joint) {
                             positionMarkerView(normalizedPoint: point, in: geometry) {
                                 VisionMarkerView(type: .yellowCicle)
                                     .frame(width: 5, height: 5)
                             }
                         }
                     }
                 } */
            }
            // Geometry reader makes the view shrink to its smallest size
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
