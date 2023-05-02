//
//  CommandPalleteView.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import SwiftUI
enum CommandIcon: String, CaseIterable {
    case applelogo = "Apple"
    case magnifyingglass = "Find"
    case circleGridHex = "Other"

    var image: Image {
        switch self {
        case .applelogo:
            return Image(systemName: "applelogo")
        case .magnifyingglass:
            return Image(systemName: "magnifyingglass")
        case .circleGridHex:
            return Image(systemName: "circle.grid.hex")
        }
    }
}

struct CommandPalleteView: View {
    @State private var selectedIcon = CommandIcon.applelogo
    @State private var command = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                selectedIcon.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.horizontal)

                Menu {
                    ForEach(CommandIcon.allCases, id: \.self) { icon in
                        Button(action: { selectedIcon = icon }) {
                            Label(icon.rawValue, systemImage: icon.rawValue.lowercased())
                        }
                    }
                } label: {
                    Image(systemName: "chevron.down")
                }
                .padding(.trailing)

                TextField("Command", text: $command)
                    .font(.system(size: 24))
                    .foregroundColor(Color.pink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        }
        .background(Color.red.opacity(0.2))
        .cornerRadius(4.0)
    }
}

struct CommandPalleteView_Previews: PreviewProvider {
    static var previews: some View {
        CommandPalleteView()
    }
}
