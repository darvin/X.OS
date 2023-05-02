//
//  AppDelegate.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import AppKit
import KeyboardShortcuts

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        let deadline = DispatchTime.now() + .milliseconds(300)

        let uiState = UIState.shared
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            uiState.isMainOverlayWindowPresented = true
        }

        KeyboardShortcuts.onKeyUp(for: .toggleOverlay) {
            DispatchQueue.main.async {
                uiState.toggleOverlay()
            }
        }

        KeyboardShortcuts.onKeyUp(for: .toggleSelecting) {
            DispatchQueue.main.async {
                uiState.toggleSelecting()
            }
        }

        KeyboardShortcuts.onKeyUp(for: .toggleCommandPallete) {
            DispatchQueue.main.async {
                uiState.toggleCommandPallete()
            }
        }
    }
}
