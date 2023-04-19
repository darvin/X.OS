//
//  TextRecognizer.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import Foundation



import Combine
import Foundation
import Vision

class TextRecognizer: VisionWorker {
    var isBusy = false
    private var subscriptions = Set<AnyCancellable>()

    func receive(subscription: Subscription) {
        subscription.request(.max(1))
        subscription.store(in: &subscriptions)
    }

    func receive(_ input: CVPixelBuffer) -> Subscribers.Demand {
        process(cvPixelBuffer: input)
        return .max(1)
    }

    func receive(completion: Subscribers.Completion<Never>) {
        
    }

    let observationsSubject = PassthroughSubject<[VNObservation], Never>()

    init() {}

    private let workQueue = makeWorkQueue()

    func process(cvPixelBuffer: CVPixelBuffer) {
        isBusy = true
        workQueue.async {
//            log.trace("heavy text recognizing")

            let textRecognitionRequest = VNRecognizeTextRequest { request, _ in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    print("The observations are of an unexpected type.")
                    return
                }
                self.observationsSubject.send(observations)
                self.isBusy = false
            }
            textRecognitionRequest.recognitionLevel = .accurate

            let requestHandler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:])

            do {
                try requestHandler.perform([textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
}
