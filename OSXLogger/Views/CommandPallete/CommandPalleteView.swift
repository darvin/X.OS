//
//  CommandPalleteView.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import SwiftUI

struct CommandPalleteView: View {
    @State private var selectedIcon = "applelogo"
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: selectedIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.horizontal)

                Menu {
                    Button(action: { selectedIcon = "applelogo" }) {
                        Label("Apple", systemImage: "applelogo")
                    }
                    Button(action: { selectedIcon = "magnifyingglass" }) {
                        Label("Find", systemImage: "magnifyingglass")
                    }
                    Button(action: { selectedIcon = "circle.grid.hex" }) {
                        Label("Other", systemImage: "circle.grid.hex")
                    }
                } label: {
                    Image(systemName: "chevron.down")
                }
                .padding(.trailing)

                TextField("Search", text: $searchText)
                    .font(.system(size: 24))
                    .foregroundColor(Color.pink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        }
    }
}

struct CommandPalleteView_Previews: PreviewProvider {
    static var previews: some View {
        CommandPalleteView()
    }
}
