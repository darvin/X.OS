//
//  SettingsView.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//


import SwiftUI
import KeyboardShortcuts

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Toggle Overlay:", name: .toggleOverlay)
        }
    }
}
