//
//  VisionMarkerView.swift
//  OSXLogger
//
//  Created by standard on 4/16/23.
//

import Foundation

import SwiftUI

enum VisionMarkerViewType {
    case redBold
    case greenThin
    case yellowCicle
}

struct VisionMarkerView: View {
    var type: VisionMarkerViewType
    var body: some View {
        switch type {
        case .redBold:
            Rectangle()
                .stroke(lineWidth: 2)
                .foregroundColor(.red.opacity(0.5))
                .accessibilityIgnoresInvertColors(true)
                .allowsHitTesting(false)

        case .greenThin:
            Rectangle()
                .stroke(lineWidth: 0.4)
                .foregroundColor(.green.opacity(0.9))
                .background(.green.opacity(0.04))
                .accessibilityIgnoresInvertColors(true)
                .allowsHitTesting(false)
        case .yellowCicle:
            Circle()
                .foregroundColor(.yellow).brightness(0.5)
                .accessibilityIgnoresInvertColors(true)
                .allowsHitTesting(false)
        }
    }
}
