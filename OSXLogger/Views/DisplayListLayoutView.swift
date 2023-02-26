//
//  ScreenListLayoutView.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import SwiftUI

struct DisplayListLayoutView: View {
    @ObservedObject var screenRecorder: ScreenRecorder

    var body: some View {
        HStack {
            ForEach(screenRecorder.availableDisplays, id: \.self) { display in
                VStack {
                    DisplayLayoutView(windows:screenRecorder.availableWindowsPerDisplay[display]!, display:display)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)


                }
            }

        }

    }
}

//struct ScreenListLayoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScreenListLayoutView()
//    }
//}
