//
//  CommandPalleteViewModel.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import Combine
import SwiftUI

enum CommandAction: String, CaseIterable {
    case command = "Command"
    case search = "Search"
    case other = "Other"

    var image: Image {
        switch self {
        case .command:
            return Image(systemName: "applelogo")
        case .search:
            return Image(systemName: "magnifyingglass")
        case .other:
            return Image(systemName: "circle.grid.hex")
        }
    }
}

class CommandPalleteViewModel: ObservableObject {
    @Published var selectedAction = CommandAction.command
    @Published var command = ""
    private var storage = Set<AnyCancellable>()

    init() {
        $command.sink { [unowned self] value in
            if value.starts(with: "/") {
                self.selectedAction = .search
            }
        }
        .store(in: &storage)
    }

    func select(action: CommandAction) {
        switch action {
        case .command:
            break
        case .search:
            if command.count == 0 {
                command = "/"
            }
        case .other:
            break
        }
        selectedAction = action
    }
}
