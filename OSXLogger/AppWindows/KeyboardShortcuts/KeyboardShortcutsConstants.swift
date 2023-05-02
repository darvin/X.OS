//
//  KeyboardShortcutsConstants.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import Foundation

import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleOverlay = Self("toggleOverlay", default: .init(.o, modifiers: [.command, .option]))

    static let toggleSelecting = Self("toggleSelecting", default: .init(.y, modifiers: [.command, .option]))

    static let toggleCommandPallete = Self("toggleCommandPallete", default: .init(.backtick, modifiers: [.command]))
}
