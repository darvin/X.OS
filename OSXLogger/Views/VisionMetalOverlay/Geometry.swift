//
//  Array_VNRectangleObservation+Vertices.swift
//  OSXLogger
//
//  Created by standard on 4/19/23.
//

import Foundation
import Vision

import simd

fileprivate struct VertexIn {
    var position: SIMD2<Float>
}



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




extension Array where Element == NormalizedRect {
    func toVertices() -> [[Vertex]] {
        map { $0.toTriangles().map { $0.toVertex() } }
    }
    
}

extension Array where Element == VNRectangleObservation {
    fileprivate func toVerticesRects() -> [[VertexIn]] {
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
    func toCornerMarkers() -> [[Vertex]] {
        return self.toNormalizedRects().flatMap { normalizedRect in
            let vInset = -normalizedRect.smallerSideLength * 0.2
            let hInset = -normalizedRect.smallerSideLength * 0.03
            return normalizedRect.withEdgeInsets(vertical: vInset, horizontal: hInset).toCornerMarkers().map { cornerMarkers in
                return cornerMarkers.toTriangles().map { vertexIn in
                    vertexIn.toVertex()
                }
            }
        }
    }
}


extension VertexIn {
    func toVertex() -> Vertex {
        let randomColor = vector_float4(Float.random(in: 0...1), Float.random(in: 0.5...1), Float.random(in: 0.5...1), 1.0)
        return Vertex(color: randomColor, pos: position)
    }
}


struct NormalizedRect {
    var topLeft: SIMD2<Float>
    var topRight: SIMD2<Float>
    var bottomRight: SIMD2<Float>
    var bottomLeft: SIMD2<Float>
}

extension NormalizedRect {
    func withEdgeInsets(vertical: Float, horizontal: Float) -> NormalizedRect {
        let xPadding = horizontal * 2
        let yPadding = vertical * 2
        
        return NormalizedRect(
            topLeft: SIMD2<Float>(topLeft.x - horizontal, topLeft.y + vertical),
            topRight: SIMD2<Float>(topRight.x + horizontal, topRight.y + vertical),
            bottomRight: SIMD2<Float>(bottomRight.x + horizontal, bottomRight.y - vertical),
            bottomLeft: SIMD2<Float>(bottomLeft.x - horizontal, bottomLeft.y - vertical)
        )
    }
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
    fileprivate func toTriangles() -> [VertexIn] {
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
        let cornerSizeV: Float = smallerSideLength * 0.2
        let cornerStrokeV: Float = smallerSideLength * 0.039
        let hRatio: Float = 0.3
        let cornerSizeH = cornerSizeV  * hRatio
        let cornerStrokeH = cornerStrokeV  * hRatio

        let topLeftHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(topLeft.x - cornerSizeH, topLeft.y),
            topRight: SIMD2<Float>(topLeft.x, topLeft.y),
            bottomRight: SIMD2<Float>(topLeft.x, topLeft.y + cornerStrokeV),
            bottomLeft: SIMD2<Float>(topLeft.x - cornerSizeH, topLeft.y + cornerStrokeV)
        )
        
        let topLeftVertical = NormalizedRect(
            topLeft: SIMD2<Float>(topLeft.x, topLeft.y + cornerSizeV),
            topRight: SIMD2<Float>(topLeft.x + cornerStrokeH, topLeft.y + cornerSizeV),
            bottomRight: SIMD2<Float>(topLeft.x + cornerStrokeH, topLeft.y),
            bottomLeft: SIMD2<Float>(topLeft.x, topLeft.y)
        )
        
        let topRightHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(topRight.x, topRight.y),
            topRight: SIMD2<Float>(topRight.x + cornerSizeH, topRight.y),
            bottomRight: SIMD2<Float>(topRight.x + cornerSizeH, topRight.y + cornerStrokeV),
            bottomLeft: SIMD2<Float>(topRight.x, topRight.y + cornerStrokeV)
        )
        
        let topRightVertical = NormalizedRect(
            topLeft: SIMD2<Float>(topRight.x - cornerStrokeH, topRight.y + cornerSizeV),
            topRight: SIMD2<Float>(topRight.x, topRight.y + cornerSizeV),
            bottomRight: SIMD2<Float>(topRight.x, topRight.y),
            bottomLeft: SIMD2<Float>(topRight.x - cornerStrokeH, topRight.y)
        )
        
        let bottomRightHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(bottomRight.x, bottomRight.y - cornerStrokeV),
            topRight: SIMD2<Float>(bottomRight.x + cornerSizeH, bottomRight.y - cornerStrokeV),
            bottomRight: SIMD2<Float>(bottomRight.x + cornerSizeH, bottomRight.y),
            bottomLeft: SIMD2<Float>(bottomRight.x, bottomRight.y)
        )
        
        let bottomRightVertical = NormalizedRect(
            topLeft: SIMD2<Float>(bottomRight.x - cornerStrokeH, bottomRight.y),
            topRight: SIMD2<Float>(bottomRight.x, bottomRight.y),
            bottomRight: SIMD2<Float>(bottomRight.x, bottomRight.y - cornerSizeV),
            bottomLeft: SIMD2<Float>(bottomRight.x - cornerStrokeH, bottomRight.y - cornerSizeV)
        )
        
        let bottomLeftHorizontal = NormalizedRect(
            topLeft: SIMD2<Float>(bottomLeft.x - cornerSizeH, bottomLeft.y - cornerStrokeV),
            topRight: SIMD2<Float>(bottomLeft.x, bottomLeft.y - cornerStrokeV),
            bottomRight: SIMD2<Float>(bottomLeft.x, bottomLeft.y),
            bottomLeft: SIMD2<Float>(bottomLeft.x - cornerSizeH, bottomLeft.y)
        )
        
        let bottomLeftVertical = NormalizedRect(
            topLeft: SIMD2<Float>(bottomLeft.x, bottomLeft.y),
            topRight: SIMD2<Float>(bottomLeft.x + cornerStrokeH, bottomLeft.y),
            bottomRight: SIMD2<Float>(bottomLeft.x + cornerStrokeH, bottomLeft.y - cornerSizeV),
            bottomLeft: SIMD2<Float>(bottomLeft.x, bottomLeft.y - cornerSizeV)
        )

        
        return [topLeftHorizontal, topLeftVertical, topRightHorizontal, topRightVertical, bottomRightHorizontal, bottomRightVertical, bottomLeftHorizontal, bottomLeftVertical]
    }
}


extension NormalizedRect {
    static func random(minSize: Float = 0.2) -> NormalizedRect {
        let sizeRange = (minSize...1.0)
        let width = Float.random(in: sizeRange)
        let height = Float.random(in: sizeRange)
        let x = Float.random(in: (-1.0 + width)...1.0)
        let y = Float.random(in: (-1.0 + height)...1.0)
        
        let topLeft = SIMD2<Float>(x, y)
        let topRight = SIMD2<Float>(x + width, y)
        let bottomRight = SIMD2<Float>(x + width, y + height)
        let bottomLeft = SIMD2<Float>(x, y + height)
        
        return NormalizedRect(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
    }
}


extension NormalizedRect {
    static func randomNonOverlappingRects(size: Int, minSize: Float = 0.2) -> [NormalizedRect] {
        var rects = [NormalizedRect]()
        
        while rects.count < size {
            let newRect = NormalizedRect.random(minSize: minSize)
            if !rects.contains(where: { $0.overlaps(with: newRect) }) {
                rects.append(newRect)
            }
        }
        
        return rects
    }
    
    func overlaps(with other: NormalizedRect) -> Bool {
        let xOverlap = (other.topLeft.x > bottomRight.x) || (topLeft.x > other.bottomRight.x)
        let yOverlap = (other.topLeft.y > bottomRight.y) || (topLeft.y > other.bottomRight.y)
        return !(xOverlap || yOverlap)
    }
}
