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
    @StateObject var uiState = UIState()
    var body: some Scene {
        MenuBarExtra("UtilityApp", systemImage: "hammer") {
            AppMenu()
                .environmentObject(screenAnalyzer)
                .environmentObject(screenRecorder)
                .environmentObject(uiState)
                .FullscreenPanel(isPresented: $uiState.isMainOverlayWindowPresented) {
                    OverlayView()
                        .environmentObject(screenAnalyzer)
                        .environmentObject(screenRecorder)
                        .environmentObject(uiState)
                }
        }
    }
}
