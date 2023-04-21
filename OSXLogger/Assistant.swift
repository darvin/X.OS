//
//  Assistant.swift
//  OSXLogger
//
//  Created by standard on 4/21/23.
//

import Foundation
import OpenAISwift
import SwiftUI

class Assistant: ObservableObject {
    private let openAIAuthToken: String
    private var openAI: OpenAISwift

    @Published
    var lastResponse = ""

    internal init() throws {
        guard let path = Bundle.main.path(forResource: "SECRET", ofType: "plist") else {
            throw NSError(domain: "BundleError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't find path to SECRET.plist"])
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw NSError(domain: "PlistError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't read contents of SECRET.plist"])
        }

        guard let token = dict["OpenAIAuthToken"] as? String else {
            throw NSError(domain: "TokenError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't find OpenAIAuthToken field in SECRET.plist"])
        }

        openAIAuthToken = token
        openAI = OpenAISwift(authToken: openAIAuthToken)
    }

    func respond(to message: String) async {
        do {
            let chat: [ChatMessage] = [
                ChatMessage(role: .system, content: "Try to come up with the best solution. optimize for runtime. be concise, explain algorithm first"),
                ChatMessage(role: .user, content: message),
            ]

            let result = try await openAI.sendChat(with: chat)

            if let txt = result.choices.first?.message.content {
                lastResponse = txt
            }

        } catch {
            lastResponse = "error :(( "
        }
    }
}
