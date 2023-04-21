//
//  UIState.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//
import SwiftUI

private let isOverlaysVisibleInitially = false

@MainActor
class UIState: ObservableObject {
    @Published
    var isSelectionWindowPresented = false

    @Published
    var isMainOverlayWindowPresented = false

    @Published
    var isCornerMarkersOverlayVisible = isOverlaysVisibleInitially

    @Published
    var isSelectingOverlayVisible = false

    @Published
    var isWindowOverlayVisible = isOverlaysVisibleInitially

    @Published
    var selectedRect: NSRect? = nil

    private var isSelecting = false

    func toggleOverlay() {
        isWindowOverlayVisible.toggle()
        isCornerMarkersOverlayVisible.toggle()
    }

    func trackMouse(point: NSPoint) {
        if isSelecting {
            if selectedRect == nil {
                selectedRect = NSRect(x: point.x - 1, y: point.y - 1, width: 3, height: 3)
            }

            selectedRect = selectedRect?.including(point: point)
            print("TRACKING Selection: \(selectedRect)")
        }
    }

    func startSelecting() {
        isSelecting = true
        isSelectingOverlayVisible = true
    }

    func endSelecting() {
        isSelecting = false
        isSelectingOverlayVisible = false
    }

    func resetSelection() {
        selectedRect = nil
    }

    func toggleSelecting() {
        if isSelecting {
            endSelecting()
        } else {
            resetSelection()
            startSelecting()
        }
    }
}

extension NSRect {
    func including(point: NSPoint) -> NSRect {
        let minX = min(self.minX, point.x)
        let minY = min(self.minY, point.y)
        let maxX = max(self.maxX, point.x)
        let maxY = max(self.maxY, point.y)
        return NSRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}