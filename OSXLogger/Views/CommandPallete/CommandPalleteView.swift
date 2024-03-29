//
//  CommandPalleteView.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import SwiftUI

struct CommandPalleteView: View {
    @StateObject var vm: CommandPalleteViewModel
    @FocusState var isFocused: Bool

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Menu {
                    ForEach(CommandAction.allCases, id: \.self) { action in
                        Button(action: { vm.select(action: action) }) {
                            HStack {
                                action.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .padding(.horizontal)
                                Text(action.rawValue)
                                    .focused($isFocused)
                            }
                        }
                    }
                } label: {
                    vm.selectedAction.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(.horizontal)
                }
                .frame(width: 40)
                .padding(.trailing)

                MaterialTextField(placeholder: "", text: $vm.command)
                    .focused($isFocused)
                    .font(.system(size: 24))
                    .foregroundColor(Color.pink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
        }
        .background(Color.red.opacity(0.2))
        .cornerRadius(4.0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
}
