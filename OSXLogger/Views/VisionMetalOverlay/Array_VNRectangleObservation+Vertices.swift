//
//  Array_VNRectangleObservation+Vertices.swift
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

import Foundation
import Vision

extension Array where Element == VNRectangleObservation {
    func toVerticesArray() -> [VertexIn] {
        return flatMap { observation in
            let bottomLeft = observation.bottomLeft
            let bottomRight = observation.bottomRight
            let topLeft = observation.topLeft
            let topRight = observation.topRight
            
            // Convert coordinates from 0.0...1.0 space to -1.0...1.0 space
            let scale: Float = 2.0
            let translate: Float = -1.0
            let bottomLeftPos = SIMD2<Float>((Float(bottomLeft.x) * scale) + translate, (Float(bottomLeft.y) * scale) + translate)
            let bottomRightPos = SIMD2<Float>((Float(bottomRight.x) * scale) + translate, (Float(bottomRight.y) * scale) + translate)
            let topLeftPos = SIMD2<Float>((Float(topLeft.x) * scale) + translate, (Float(topLeft.y) * scale) + translate)
            let topRightPos = SIMD2<Float>((Float(topRight.x) * scale) + translate, (Float(topRight.y) * scale) + translate)
            
            return [
                // First triangle
                VertexIn(position: bottomLeftPos),
                 VertexIn(position: topLeftPos),
                 VertexIn(position: topRightPos),
                // Second triangle
                VertexIn(position: bottomLeftPos),
                 VertexIn(position: topRightPos),
                 VertexIn(position: bottomRightPos)
            ]

        }
    }
}

