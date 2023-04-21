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
        Text(selectionViewModel.selectedText)
        Spacer()
        Text(selectionViewModel.responseText)
    }
}
