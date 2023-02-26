//
//  OSXLoggerApp.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import SwiftUI

class MyWindow: NSPanel {
    
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = MyWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 270),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered, defer: false)
        window.center()
        window.title = "No Storyboard Window"
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)))
        window.contentView = NSHostingView(rootView: ContentView())
        window.ignoresMouseEvents = true
        let screenFrame = NSScreen.main?.frame
//        window.collectionBehavior = NSWindow.CollectionBehavior.fullScreenPrimary
        window.setFrame(screenFrame!, display: true)
//        window.toggleFullScreen(self)
        
//        window.level = Int(CGWindowLevelForKey(.maximumWindowLevelKey))
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        window.makeKeyAndOrderFront(nil)

    }
}




