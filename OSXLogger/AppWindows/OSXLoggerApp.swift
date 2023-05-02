//
//  OSXLoggerApp.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import AXSwift
import SwiftUI

import SwiftUI

@main
struct XOSApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var screenRecorder = ScreenRecorder()
    @StateObject var screenAnalyzer = ScreenAnalyzer()
    @StateObject var uiState = UIState.shared

    @State var isCommandPalleteOverlayPresented = true

    var body: some Scene {
        MenuBarExtra("UtilityApp", systemImage: "apple.logo") {
            AppMenu()
                .environmentObject(screenAnalyzer)
                .environmentObject(screenRecorder)
                .environmentObject(uiState)
                .overlayPanel(isPresented: $uiState.isMainOverlayWindowPresented, ignoresMouseEvents: true, fullscreen: true) {
                    OverlayView()
                        .environmentObject(screenAnalyzer)
                        .environmentObject(screenRecorder)
                        .environmentObject(uiState)
                }

                .overlayPanel(isPresented: $isCommandPalleteOverlayPresented, contentRect: CGRect(x: 0, y: 0, width: Int(CommandPalleteOverlayView.overlayWidthRatio * NSScreen.main!.frame.width), height: CommandPalleteOverlayView.overlayHeight)) {
                    CommandPalleteOverlayView()
                        //                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .environmentObject(screenAnalyzer)
                        .environmentObject(screenRecorder)
                        .environmentObject(uiState)
                }
        }

        Window("Selection", id: "selection") {
            SelectionView(selectionViewModel: SelectionViewModel(uiState: uiState, screenAnalyzer: screenAnalyzer))
        }
    }
}
