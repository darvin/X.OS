//
//  SelectionViewModel.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import Foundation

import Combine
import SwiftUI
import Vision

@MainActor
class SelectionViewModel: ObservableObject {
//    @ObservedObject
    var uiState: UIState

//    @ObservedObject
    var screenAnalyzer: ScreenAnalyzer

    @Published var selectedTextObservations: [VNRecognizedTextObservation] = []
    @Published var selectedText = ""

    @Published var responseText = ""

    @Published var isLoading = false

    private var subscriptions = Set<AnyCancellable>()

    private let assistant = try! Assistant()

    init(uiState: UIState, screenAnalyzer: ScreenAnalyzer) {
        self.uiState = uiState
        self.screenAnalyzer = screenAnalyzer

        uiState.$isSelecting.sink { isSelecting in
            if !isSelecting {
                Task {
                    await self.assistant.respond(to: self.selectedText)
                    self.responseText = self.assistant.lastResponse
                    self.uiState.resetSelection()
                }
            }
        }
        .store(in: &subscriptions)

        assistant.$isWorking.sink {
            self.isLoading = $0
        }
        .store(in: &subscriptions)

        screenAnalyzer.$text.sink { text in
            guard let selectedRect = uiState.selectedRect else {
                self.selectedTextObservations = []
                self.selectedText = ""
                return
            }
            self.selectedTextObservations = text.filter { txt in
                let denormalizedRect = DenormalizedRect(txt.boundingBox, forSize: NSScreen.main!.frame.size)
                return selectedRect.intersects(denormalizedRect)
            }.sortedByBoundingBox()

            self.selectedText = self.selectedTextObservations.joinedText()
        }
        .store(in: &subscriptions)
    }
}

extension Array where Element == VNRecognizedTextObservation {
    func sortedByBoundingBox() -> [VNRecognizedTextObservation] {
        return sorted { obs1, obs2 -> Bool in
            let box1 = obs1.boundingBox
            let box2 = obs2.boundingBox

            if box1.minY > box2.minY {
                return true
            } else if box1.minY == box2.minY {
                return box1.minX > box2.minX
            } else {
                return false
            }
        }
    }
}

extension Array where Element == VNRecognizedTextObservation {
    func joinedText() -> String {
        var lines: [[VNRecognizedTextObservation]] = []

        // Group observations into lines based on vertical position
        for observation in self {
            let box: CGRect = observation.boundingBox
            let text: String = observation.topCandidates(1).first!.string

            // Find the index of the line that this observation belongs to, or create a new line
            var lineIndex = -1
            for (index, line) in lines.enumerated() {
                let lastBox: CGRect = line.last!.boundingBox
                if abs(lastBox.minY - box.minY) < 0.01 { // Allow for small difference due to rounding errors
                    lineIndex = index
                    break
                }
            }

            if lineIndex == -1 {
                lines.append([observation])
            } else {
                lines[lineIndex].append(observation)
            }
        }

        // Sort each line by horizontal position
        for i in 0 ..< lines.count {
            lines[i].sort { obs1, obs2 -> Bool in
                obs1.boundingBox.minX < obs2.boundingBox.minX
            }
        }

        // Join text within each line with spaces, and lines with newlines
        var result = ""
        for line in lines {
            let lineText: String = line.map { $0.topCandidates(1).first!.string }.joined(separator: " ")
            result += lineText + "\n"
        }

        return result
    }
}

func DenormalizedPoint(_ normalized: CGPoint, forSize: CGSize) -> CGPoint {
    return VNImagePointForNormalizedPoint(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}

func DenormalizedRect(_ normalized: CGRect, forSize: CGSize) -> CGRect {
    return VNImageRectForNormalizedRect(normalized, Int(forSize.width), Int(forSize.height)).applying(.init(scaleX: 1, y: -1)).applying(.init(translationX: 0, y: forSize.height))
}
