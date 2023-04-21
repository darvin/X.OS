//
//  SettingsView.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import KeyboardShortcuts
import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Toggle Overlay:", name: .toggleOverlay)
        }
    }
}
