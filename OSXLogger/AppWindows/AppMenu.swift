//
//  AppMenu.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import SwiftUI

struct AppMenu: View {
    @EnvironmentObject var uiState: UIState

    var body: some View {
        VStack {
            Toggle("Window Overlay", isOn: $uiState.isWindowOverlayVisible)
            Toggle("Corner Marker Overlay", isOn: $uiState.isCornerMarkersOverlayVisible)
            Toggle("Main Window Presented", isOn: $uiState.isMainOverlayWindowPresented)
        }
    }
}
