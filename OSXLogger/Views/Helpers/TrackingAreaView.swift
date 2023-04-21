//
//  TrackingAreaView.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import SwiftUI

extension View {
    func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
        TrackinAreaView(onMove: onMove) { self }
    }
}

struct TrackinAreaView<Content>: View where Content: View {
    let onMove: (NSPoint) -> Void
    let content: () -> Content

    init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onMove = onMove
        self.content = content
    }

    var body: some View {
        TrackingAreaRepresentable(onMove: onMove, content: self.content())
    }
}

struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    let onMove: (NSPoint) -> Void
    let content: Content

    func makeNSView(context _: Context) -> NSHostingView<Content> {
        return TrackingNSHostingView(onMove: onMove, rootView: content)
    }

    func updateNSView(_: NSHostingView<Content>, context _: Context) {}
}

class TrackingNSHostingView<Content>: NSHostingView<Content> where Content: View {
    let onMove: (NSPoint) -> Void

    init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
        self.onMove = onMove

        super.init(rootView: rootView)

        setupTrackingArea()
    }

    required init(rootView _: Content) {
        fatalError("init(rootView:) has not been implemented")
    }

    @available(*, unavailable)
    @objc dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
        addTrackingArea(NSTrackingArea(rect: .zero, options: options, owner: self, userInfo: nil))
    }

    override func mouseMoved(with event: NSEvent) {
        onMove(convert(event.locationInWindow, from: nil))
    }
}
