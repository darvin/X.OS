//
//  OverlayPanel.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import SwiftUI

private struct OverlayPanelModifier<PanelContent: View>: ViewModifier {
    @Binding var isPresented: Bool

    var ignoresMouseEvents = false
    var fullscreen = false

    var contentRect: CGRect = .init(x: 0, y: 0, width: 624, height: 512)

    /// Holds the panel content's view closure
    @ViewBuilder let view: () -> PanelContent

    /// Stores the panel instance with the same generic type as the view closure
    @State var panel: OverlayPanel<PanelContent>?

    func body(content: Content) -> some View {
        content
            .onAppear {
                /// When the view appears, create, center and present the panel if ordered
                panel = OverlayPanel(view: view, contentRect: contentRect, isPresented: $isPresented, fullscreen: fullscreen)
                panel?.ignoresMouseEvents = ignoresMouseEvents
//                panel?.center()
                if isPresented {
                    present()
                }
            }.onDisappear {
                /// When the view disappears, close and kill the panel
                panel?.close()
                panel = nil
            }.onChange(of: isPresented) { value in
                /// On change of the presentation state, make the panel react accordingly
                if value {
                    present()
                } else {
                    panel?.close()
//                    panel = nil
                }
            }
    }

    /// Present the panel and make it the key window
    func present() {
        panel?.orderFront(nil)
        panel?.makeKey()
    }
}

class OverlayPanel<Content: View>: NSPanel {
    @Binding var isPresented: Bool
    let fullscreen: Bool
    init(@ViewBuilder view: @escaping () -> Content,
         contentRect: NSRect,
         backing: NSWindow.BackingStoreType = .buffered,
         defer flag: Bool = false,
         isPresented: Binding<Bool>,
         fullscreen: Bool = false)
    {
        /// Initialize the binding variable by assigning the whole value via an underscore
        _isPresented = isPresented
        self.fullscreen = fullscreen

        /// Init the window as usual
        super.init(contentRect: contentRect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: backing,
                   defer: flag)

        /// Allow the panel to be on top of other windows
//        isFloatingPanel = true
//        level = .floating

        /// Allow the pannel to be overlaid in a Overlay space
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        titlebarAppearsTransparent = true
        isOpaque = false
        backgroundColor = NSColor.clear
        level = .mainMenu + 100

        contentView = NSHostingView(rootView: view()
            .ignoresSafeArea()
            .environment(\.OverlayPanel, self))
    }

    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
//        if fullscreen {
//            if let screenFrame = screen?.frame {
//                return screenFrame
//            } else if let screenFrame = NSScreen.main?.frame {
//                return screenFrame
//            }
//        }

        var mainScreen = screen ?? NSScreen.main

        guard let mainScreen else {
            return super.constrainFrameRect(frameRect, to: nil)
        }

        guard !fullscreen else {
            return mainScreen.visibleFrame
        }

        var newRect = frameRect

        // Set the X coordinate to center the frame on the screen
        newRect.origin.x = mainScreen.visibleFrame.origin.x + (mainScreen.visibleFrame.width - frameRect.width) / 2

        // Set the Y coordinate to position the frame at the bottom of the screen
        newRect.origin.y = 30

        return newRect
    }

    /// Close automatically when out of focus, e.g. outside click
    override func resignMain() {
        super.resignMain()
//        if !fullscreen {
//            close()
//        }
    }

    /// Close and toggle presentation, so that it matches the current state of the panel
    override func close() {
        super.close()
//        isPresented = false
    }

    /// `canBecomeKey` and `canBecomeMain` are both required so that text inputs inside the panel can receive focus
    override var canBecomeKey: Bool {
        return !fullscreen
    }

    override var canBecomeMain: Bool {
        return !fullscreen
    }
}

private struct OverlayPanelKey: EnvironmentKey {
    static let defaultValue: NSPanel? = nil
}

extension EnvironmentValues {
    var OverlayPanel: NSPanel? {
        get { self[OverlayPanelKey.self] }
        set { self[OverlayPanelKey.self] = newValue }
    }
}

extension View {
    /** Present a ``OverlayPanel`` in SwiftUI fashion
     - Parameter isPresented: A boolean binding that keeps track of the panel's presentation state
     - Parameter contentRect: The initial content frame of the window
     - Parameter content: The displayed content
     **/
    func overlayPanel<Content: View>(isPresented: Binding<Bool>,
                                     ignoresMouseEvents: Bool = false,
                                     fullscreen: Bool = false,
                                     contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512),
                                     @ViewBuilder content: @escaping () -> Content) -> some View
    {
        modifier(OverlayPanelModifier(isPresented: isPresented, ignoresMouseEvents: ignoresMouseEvents, fullscreen: fullscreen, contentRect: contentRect, view: content))
    }
}
