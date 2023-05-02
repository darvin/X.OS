//
//  CommandPalleteOverlayView.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import SwiftUI

struct CommandPalleteOverlayView: View {
    @EnvironmentObject var uiState: UIState

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .center) {
                if uiState.isCommandPalletePresented {
                    CommandPalleteView()
                }
            }
        }
    }
}

struct CommandPalleteOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        CommandPalleteOverlayView()
    }
}
