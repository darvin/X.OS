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





extension Array where Element == VNRectangleObservation {
    func toCornerMarkers() -> [[VertexIn]] {
        return self.toNormalizedRects().flatMap { normalizedRect in
            return normalizedRect.toCornerMarkers().map { cornerMarkers in
                return cornerMarkers.toTriangles()
            }
        }
    }
}





struct NormalizedRect {
    var topLeft: SIMD2<Float>
    var topRight: SIMD2<Float>
    var bottomRight: SIMD2<Float>
    var bottomLeft: SIMD2<Float>
}
extension NormalizedRect {
    var width: Float {
        return topRight.x - topLeft.x
    }

    var height: Float {
        return bottomLeft.y - topLeft.y
    }

    var size: SIMD2<Float> {
        return SIMD2<Float>(width, height)
    }

    var smallerSideLength: Float {
        return min(width, height)
    }
}



extension Array where Element == VNRectangleObservation {
    func toNormalizedRects() -> [NormalizedRect] {
        let scale: Float = 2.0
        let translate: Float = -1.0
        
        return map { observation in
            let topLeft = observation.topLeft.toSIMD2(scale: scale, translate: translate)
            let topRight = observation.topRight.toSIMD2(scale: scale, translate: translate)
            let bottomRight = observation.bottomRight.toSIMD2(scale: scale, translate: translate)
            let bottomLeft = observation.bottomLeft.toSIMD2(scale: scale, translate: translate)
            
            return NormalizedRect(
                topLeft: topLeft,
                topRight: topRight,
                bottomRight: bottomRight,
                bottomLeft: bottomLeft
            )
        }
    }
}



extension NormalizedRect {
    func toTriangles() -> [VertexIn] {
        let triangle1 = [
            VertexIn(position: bottomLeft),
            VertexIn(position: topLeft),
            VertexIn(position: topRight)
        ]
        let triangle2 = [
            VertexIn(position: bottomLeft),
            VertexIn(position: topRight),
            VertexIn(position: bottomRight)
        ]
        return triangle1 + triangle2
    }
}

extension NormalizedRect {
    func toCornerMarkers() -> [NormalizedRect] {
        let cornerSize: Float = smallerSideLength * 0.4
        let cornerStroke: Float = smallerSideLength * 0.1
        
        let topLeftHorizonal = NormalizedRect(
            topLeft: SIMD2<Float>(topLeft.x, topLeft.y),
            topRight: SIMD2<Float>(topLeft.x + cornerSize, topLeft.y),
            bottomRight: SIMD2<Float>(topLeft.x + cornerSize, topLeft.y - cornerStroke),
            bottomLeft: SIMD2<Float>(topLeft.x, topLeft.y - cornerStroke)
        )
        
        let topLeftVertical = NormalizedRect(
            topLeft: SIMD2<Float>(topLeft.x, topLeft.y),
            topRight: SIMD2<Float>(topLeft.x + cornerStroke, topLeft.y),
            bottomRight: SIMD2<Float>(topLeft.x + cornerStroke, topLeft.y - cornerSize),
            bottomLeft: SIMD2<Float>(topLeft.x, topLeft.y - cornerSize)
        )
        
        let topRightHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(topRight.x - cornerSize, topRight.y),
            topRight: SIMD2<Float>(topRight.x, topRight.y),
            bottomRight: SIMD2<Float>(topRight.x, topRight.y - cornerStroke),
            bottomLeft: SIMD2<Float>(topRight.x - cornerSize, topRight.y - cornerStroke)
        )
        
        let topRightVertical = NormalizedRect(
            topLeft: SIMD2<Float>(topRight.x - cornerStroke, topRight.y),
            topRight: SIMD2<Float>(topRight.x, topRight.y),
            bottomRight: SIMD2<Float>(topRight.x, topRight.y - cornerSize),
            bottomLeft: SIMD2<Float>(topRight.x - cornerStroke, topRight.y - cornerSize)
        )
        
        let bottomRightHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(bottomRight.x - cornerSize, bottomRight.y + cornerStroke),
            topRight: SIMD2<Float>(bottomRight.x, bottomRight.y + cornerStroke),
            bottomRight: SIMD2<Float>(bottomRight.x, bottomRight.y),
            bottomLeft: SIMD2<Float>(bottomRight.x - cornerSize, bottomRight.y)
        )
        
        let bottomRightVertical = NormalizedRect(
            topLeft: SIMD2<Float>(bottomRight.x - cornerStroke, bottomRight.y + cornerSize),
            topRight: SIMD2<Float>(bottomRight.x, bottomRight.y + cornerSize),
            bottomRight: SIMD2<Float>(bottomRight.x, bottomRight.y),
            bottomLeft: SIMD2<Float>(bottomRight.x - cornerStroke, bottomRight.y)
        )
        
        let bottomLeftHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(bottomLeft.x, bottomLeft.y + cornerStroke),
            topRight: SIMD2<Float>(bottomLeft.x + cornerSize, bottomLeft.y + cornerStroke),
            bottomRight: SIMD2<Float>(bottomLeft.x + cornerSize, bottomLeft.y),
            bottomLeft: SIMD2<Float>(bottomLeft.x, bottomLeft.y)
        )
        
        let bottomLeftVertical = NormalizedRect(
            topLeft: SIMD2<Float>(bottomLeft.x, bottomLeft.y + cornerSize),
            topRight: SIMD2<Float>(bottomLeft.x + cornerStroke, bottomLeft.y + cornerSize),
            bottomRight: SIMD2<Float>(bottomLeft.x + cornerStroke, bottomLeft.y),
            bottomLeft: SIMD2<Float>(bottomLeft.x, bottomLeft.y)
        )
        
        return [topLeftHorizonal, topLeftVertical, topRightHorizontal, topRightVertical, bottomRightHorizontal, bottomRightVertical, bottomLeftHorizontal, bottomLeftVertical]
    }
}


