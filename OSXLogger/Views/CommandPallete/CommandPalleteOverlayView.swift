//
//  CommandPalleteOverlayView.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import SwiftUI

struct CommandPalleteOverlayView: View {
    static let overlayWidthRatio = 0.8
    static let overlayHeight = 40

    @EnvironmentObject var uiState: UIState
    @EnvironmentObject var screenAnalyzer: ScreenAnalyzer

    var body: some View {
//        HStack(alignment: .bottom) {
//            VStack(alignment: .center) {
        if uiState.isCommandPalletePresented {
            CommandPalleteView(vm: CommandPalleteViewModel(screenAnalyzer: screenAnalyzer))
                .frame(width: CommandPalleteOverlayView.overlayWidthRatio * NSScreen.main!.frame.width)
        }
//            }
//        }
    }
}

struct CommandPalleteOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        CommandPalleteOverlayView()
    }
}
