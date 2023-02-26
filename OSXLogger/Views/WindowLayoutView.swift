//
//  WindowLayoutView.swift
//  OSXLogger
//
//  Created by standard on 2/26/23.
//

import SwiftUI
import ScreenCaptureKit


extension SCWindow {
    var icon: NSImage? {
        guard let bundleIdentifier = owningApplication?.bundleIdentifier else {return nil }
        guard let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) else {return nil }
        guard let bundle = Bundle(url: appURL) else {return nil }

        guard let iconName = bundle.infoDictionary?["CFBundleIconFile"] as? String else {return nil }
        guard let iconPath = bundle.path(forResource: iconName, ofType: "icns") else {return nil }
        guard  let icon = NSImage(contentsOfFile: iconPath) else {return nil }
    
        
        return icon
                
        
    }
}

struct WindowLayoutView: View {
    var window: SCWindow
    var inDisplay: SCDisplay

    var body: some View {
        ZStack {
            Color.red.opacity(0.4)
            Rectangle()
                .stroke(Color.yellow, lineWidth: 2)
            VStack {
                HStack {
                    if let icon = window.icon {
                        Image(nsImage:icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)

                    }
                    Text("\(window.title ?? "- n/a -")")
                        .minimumScaleFactor(0.1)

                }
                Divider()
                Spacer()
            }

        }
        
//        .aspectRatio(CGSize(width: window.frame.width, height: window.frame.height), contentMode: .fit)

    }
}

//struct WindowLayoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        WindowLayoutView()
//    }
//}
