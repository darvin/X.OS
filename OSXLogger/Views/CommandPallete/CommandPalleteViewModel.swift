//
//  CommandPalleteViewModel.swift
//  OSXLogger
//
//  Created by standard on 5/2/23.
//

import Combine
import SwiftUI
import Vision

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
    var screenAnalyzer: ScreenAnalyzer
    private var storage = Set<AnyCancellable>()

    init(screenAnalyzer: ScreenAnalyzer) {
        self.screenAnalyzer = screenAnalyzer
        $command.sink { [unowned self] value in

            self.onUpdate(command: value)
        }
        .store(in: &storage)
    }

    func onUpdate(command: String) {
        if command.starts(with: "/") {
            selectedAction = .search

            var searchTerm = command
            searchTerm.remove(at: searchTerm.startIndex)
            DispatchQueue.main.async {
                self.set(searchTerm: searchTerm)
            }
        }
    }

    @MainActor private func set(searchTerm: String) {
        screenAnalyzer.textFilter = { txtObservation in
            if searchTerm == "*" {
                return true
            }
            let txt = txtObservation.topCandidates(1)[0].string
            return txt.lowercased().contains(searchTerm.lowercased())
        }
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
