//
//  AppMenu.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import SwiftUI

struct AppMenu: View {
    @EnvironmentObject var uiState: UIState
    @Environment(\.openWindow) var openWindow

    var body: some View {
        VStack {
            Toggle("Window Overlay", isOn: $uiState.isWindowOverlayVisible)
            Toggle("Corner Marker Overlay", isOn: $uiState.isCornerMarkersOverlayVisible)
            Toggle("Overlay Window", isOn: $uiState.isMainOverlayWindowPresented)
            Button("Selection Window") {
                openWindow(id: "selection")
            }
        }
    }
}
