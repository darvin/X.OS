//
//  OverlayPanel.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import Foundation

import SwiftUI

/// Add a  ``FullscreenPanel`` to a view hierarchy
private struct FullscreenPanelModifier<PanelContent: View>: ViewModifier {
    /// Determines wheter the panel should be presented or not
    @Binding var isPresented: Bool

    /// Determines the starting size of the panel
    var contentRect: CGRect = .init(x: 0, y: 0, width: 624, height: 512)

    /// Holds the panel content's view closure
    @ViewBuilder let view: () -> PanelContent

    /// Stores the panel instance with the same generic type as the view closure
    @State var panel: FullscreenPanel<PanelContent>?

    func body(content: Content) -> some View {
        content
            .onAppear {
                /// When the view appears, create, center and present the panel if ordered
                panel = FullscreenPanel(view: view, contentRect: contentRect, isPresented: $isPresented)
                panel?.center()
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
                }
            }
    }

    /// Present the panel and make it the key window
    func present() {
        panel?.orderFront(nil)
        panel?.makeKey()
    }
}

class FullscreenPanel<Content: View>: NSPanel {
    @Binding var isPresented: Bool
    init(view: () -> Content,
         contentRect: NSRect,
         backing: NSWindow.BackingStoreType = .buffered,
         defer flag: Bool = false,
         isPresented: Binding<Bool>)
    {
        /// Initialize the binding variable by assigning the whole value via an underscore
        _isPresented = isPresented

        /// Init the window as usual
        super.init(contentRect: contentRect,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: backing,
                   defer: flag)

        /// Allow the panel to be on top of other windows
        isFloatingPanel = true
        level = .floating

        /// Allow the pannel to be overlaid in a fullscreen space
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        titlebarAppearsTransparent = true
        isOpaque = false
//        backgroundColor = NSColor(calibratedWhite: 0.3, alpha: 0.4)
        backgroundColor = NSColor.clear
        level = NSWindow.Level.mainMenu + 1
        ignoresMouseEvents = true

        contentView = NSHostingView(rootView: view()
            .ignoresSafeArea()
            .environment(\.FullscreenPanel, self))
    }

    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        if let screenFrame = screen?.frame {
            return screenFrame
        } else if let screenFrame = NSScreen.main?.frame {
            return screenFrame
        }
        return frameRect
    }
}

private struct FullscreenPanelKey: EnvironmentKey {
    static let defaultValue: NSPanel? = nil
}

extension EnvironmentValues {
    var FullscreenPanel: NSPanel? {
        get { self[FullscreenPanelKey.self] }
        set { self[FullscreenPanelKey.self] = newValue }
    }
}

extension View {
    /** Present a ``FullscreenPanel`` in SwiftUI fashion
     - Parameter isPresented: A boolean binding that keeps track of the panel's presentation state
     - Parameter contentRect: The initial content frame of the window
     - Parameter content: The displayed content
     **/
    func FullscreenPanel<Content: View>(isPresented: Binding<Bool>,
                                        contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512),
                                        @ViewBuilder content: @escaping () -> Content) -> some View
    {
        modifier(FullscreenPanelModifier(isPresented: isPresented, contentRect: contentRect, view: content))
    }
}
