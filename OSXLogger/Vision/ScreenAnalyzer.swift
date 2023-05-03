//
//  ScreenAnalyzer.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import Combine
import Foundation
import SwiftUI
import Vision

#if os(iOS)
    typealias VNEdgeInsets = UIEdgeInsets
#else
    typealias VNEdgeInsets = NSEdgeInsets
    extension CGRect {
        func inset(by insets: NSEdgeInsets) -> CGRect {
            return CGRect(x: origin.x + insets.left,
                          y: origin.y + insets.top,
                          width: size.width - (insets.left + insets.right),
                          height: size.height - (insets.top + insets.bottom))
        }
    }

#endif

extension Array where Element == VNRectangleObservation {
    func isAlmostEqual(with insets: VNEdgeInsets, to other: [VNRectangleObservation]) -> Bool {
        guard count == other.count else { return false }
        for (index, observation) in enumerated() {
            let otherObservation = other[index]
            let rect = observation.boundingBox
            let otherRect = otherObservation.boundingBox
            let insetRect = rect.inset(by: insets)
            let otherInsetRect = otherRect.inset(by: insets)
            if insetRect != otherInsetRect {
                return false
            }
        }
        return true
    }
}

@MainActor
class ScreenAnalyzer: ObservableObject {
    @Published var objects: [VNRecognizedObjectObservation] = []
    @Published var text: [VNRecognizedTextObservation] = []
    @Published var hands: [VNHumanHandPoseObservation] = []
    @Published var humanBodyPoses: [VNHumanBodyPoseObservation] = []

    var textFilter: (VNRecognizedTextObservation) -> Bool = { _ in
        false
    }

    private var _screenRecorder: ScreenRecorder?
    private var subscriptions = Set<AnyCancellable>()
    private let textRecognizer = TextRecognizer()

    var screenRecorder: ScreenRecorder? {
        set {
            _screenRecorder = newValue

            let pixelBufferPublisher = _screenRecorder!.cvBufferSubject
            let observationPublisher = textRecognizer.observationsSubject
            let backgroundQueue = DispatchQueue.global(qos: .userInteractive)

            pixelBufferPublisher
                //            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
//                .throttle(for: .seconds(0.1), scheduler: RunLoop.main, latest: true)
                .receive(on: backgroundQueue)
                .subscribe(textRecognizer)
            observationPublisher.send([])

            Publishers.RemoveDuplicates(
                upstream: observationPublisher.eraseToAnyPublisher(),
                //                .debounce(for: .seconds(0.01), scheduler: RunLoop.main) //debounce will erase absolutely any camera observation
                predicate: {
//                    return false
                    guard let rects1 = $0 as? [VNRectangleObservation],
                          let rects2 = $1 as? [VNRectangleObservation]
                    else {
                        return $0 == $1
                    }
                    let isEqual = rects1.isAlmostEqual(with: VNEdgeInsets(top: 3.2, left: 10, bottom: 3.3, right: 10), to: rects2)
                    if isEqual, rects1.count > 0 {
                        print("is equal")
                    }
                    return isEqual
                }
            )

            .receive(on: RunLoop.main)
            .sink { [unowned self] observations in
                self.objects = observations.filter { $0 is VNRecognizedObjectObservation } as! [VNRecognizedObjectObservation]
                self.text = (observations.filter { $0 is VNRecognizedTextObservation } as! [VNRecognizedTextObservation]).filter(self.textFilter)
                self.hands = observations.filter { $0 is VNHumanHandPoseObservation } as! [VNHumanHandPoseObservation]
                self.humanBodyPoses = observations.filter { $0 is VNHumanBodyPoseObservation } as! [VNHumanBodyPoseObservation]

                print(Date())
            }.store(in: &subscriptions)
        }
        get {
            _screenRecorder
        }
    }

    init() {}
}

extension CVPixelBuffer {
    func isAlmostEqual(to another: CVPixelBuffer) -> Bool {
        let old = self
        let new = another
        CVPixelBufferLockBaseAddress(old, .readOnly)
        CVPixelBufferLockBaseAddress(new, .readOnly)
        let oldP = CVPixelBufferGetBaseAddress(old)
        let newP = CVPixelBufferGetBaseAddress(new)

        let oldBuf = unsafeBitCast(oldP, to: UnsafeMutablePointer<UInt8>.self)
        let newBuf = unsafeBitCast(newP, to: UnsafeMutablePointer<UInt8>.self)

        let oldLen = CVPixelBufferGetDataSize(old)
        let newLen = CVPixelBufferGetDataSize(new)

        var isEqual = (oldLen == newLen)

        var differentBytes = 0
        let differentBytesTreshold = newLen / 100

        if oldLen == newLen && oldLen > 0 {
            for i in 0 ..< oldLen {
                if oldBuf[i] != newBuf[i] {
                    differentBytes += 1
                    if differentBytes >= differentBytesTreshold {
                        isEqual = false
                        break
                    }
                }
            }
        }

        CVPixelBufferUnlockBaseAddress(old, .readOnly)
        CVPixelBufferUnlockBaseAddress(new, .readOnly)

        return isEqual
    }
}
