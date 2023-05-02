//
//  SelectionView.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import SwiftUI

struct SelectionView: View {
    @StateObject var selectionViewModel: SelectionViewModel
    var body: some View {
        ScrollView {
            VStack {
                TextEditor(text: $selectionViewModel.selectedText)
                    .font(.system(size: 14))
                    .italic()
                    .textFieldStyle(.roundedBorder)
//                    .lineLimit(5, reservesSpace: true)
                Spacer()

                if selectionViewModel.isLoading {
                    ProgressView()
                } else {
                    Text(selectionViewModel.responseText)
                        .font(.system(size: 24))
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
            }
        }
    }
}
