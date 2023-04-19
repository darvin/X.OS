//
//  Array_VNRectangleObservation+Vertices.swift
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

import Foundation
import Vision
extension CGPoint {
    func toSIMD2(scale: Float, translate: Float) -> SIMD2<Float> {
        let x = Float(self.x) * scale + translate
        let y = Float(self.y) * scale + translate
        return SIMD2<Float>(x, y)
    }

    func translatedBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}

extension SIMD2 where Scalar == Float {
    func toCGPoint(scale: Float, translate: Float) -> CGPoint {
        let x = CGFloat((self.x - translate) / scale)
        let y = CGFloat((self.y - translate) / scale)
        return CGPoint(x: x, y: y)
    }
}

extension Array where Element == VNRectangleObservation {
    func toVerticesRects() -> [[VertexIn]] {
        let scale: Float = 2.0
        let translate: Float = -1.0

        return map { observation in
            let points = [observation.bottomLeft, observation.bottomRight, observation.topLeft, observation.topRight]
            let vertices = points.map { point in
                point.toSIMD2(scale: scale, translate: translate)
            }

            let triangle1 = [vertices[0], vertices[2], vertices[3]]
            let triangle2 = [vertices[0], vertices[3], vertices[1]]
            let flattenedVertices = triangle1 + triangle2

            return flattenedVertices.map { vertex in
                VertexIn(position: vertex)
            }
        }
    }
}
