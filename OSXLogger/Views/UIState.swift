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
    var isCornerMarkersOverlayVisible = isOverlaysVisibleInitially

    @Published
    var isSelectingOverlayVisible = false

    @Published
    var isWindowOverlayVisible = isOverlaysVisibleInitially

    private var isSelecting = false

//    @Published
//    var selectedObservations

    func toggleOverlay() {
        isWindowOverlayVisible.toggle()
        isCornerMarkersOverlayVisible.toggle()
    }

    func trackMouse(point _: NSPoint) {
        if isSelecting {}
    }

    func startSelecting() {
        isSelecting = true
        isSelectingOverlayVisible = true
    }

    func endSelecting() {
        isSelecting = false
        isSelectingOverlayVisible = false
    }

    func resetSelection() {}

    func toggleSelecting() {
        if isSelecting {
            endSelecting()
        } else {
            resetSelection()
            startSelecting()
        }
    }
}
