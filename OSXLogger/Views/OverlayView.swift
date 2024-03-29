//
//  ContentView.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import SwiftUI

import Combine
import KeyboardShortcuts
import OSLog
import ScreenCaptureKit
import SwiftUI

struct OverlayView: View {
    @State var isUnauthorized = false

    @EnvironmentObject var screenRecorder: ScreenRecorder
    @EnvironmentObject var screenAnalyzer: ScreenAnalyzer
    @EnvironmentObject var uiState: UIState

    @State var theWindow: NSWindow?

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            /*
             DisplayListLayoutView(screenRecorder: screenRecorder)
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                 .opacity(uiState.isWindowOverlayVisible ? 0.1 : 0.0)*/

            if uiState.isSelectingOverlayVisible {
                VisionOverlayView(selectionViewModel: SelectionViewModel(uiState: uiState, screenAnalyzer: screenAnalyzer))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            MetalView()
//                .background(Color.red.opacity(0.1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .opacity(uiState.isCornerMarkersOverlayVisible ? 0.7 : 0.0)
                .environmentObject(screenAnalyzer)
        }
        .overlay {
            if isUnauthorized {
                VStack {
                    Spacer()
                    VStack {
                        Text("No screen recording permission.")
                            .font(.largeTitle)
                            .padding(.top)
                        Text("Open System Settings and go to Privacy & Security > Screen Recording to grant permission.")
                            .font(.title2)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(.red)
                }
            }
        }
        .trackingMouse(onMove: { point in
            uiState.trackMouse(point: point)
        })
        .onAppear {
            screenAnalyzer.screenRecorder = screenRecorder
            Task {
                if await screenRecorder.canRecord {
                    await screenRecorder.start()
                } else {
                    isUnauthorized = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView()
    }
}
