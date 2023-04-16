//
//  VisionWorker.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import Combine
import Foundation
import Vision

protocol VisionWorker: Subscriber where Input == CVPixelBuffer, Failure == Never {
    var observationsSubject: PassthroughSubject<[VNObservation], Never> { get }
    var isBusy: Bool { get }
}

extension VisionWorker {
    static func makeWorkQueue() -> DispatchQueue {
        DispatchQueue(label: "VisionWorkerQueue-\(UUID())",
                      qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    }
}

