//
//  MaterialTextField.swift
//  OSXLogger
//
//  Created by standard on 5/3/23.
//

import Foundation

import SwiftUI

struct MaterialTextField: View {
    let placeholder: String
    @Binding var text: String
    @State var isFocus: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BorderlessTextField(placeholder: placeholder, text: $text, isFocus: $isFocus)
                .frame(maxHeight: 40)
            Rectangle()
                .foregroundColor(Color.yellow) // (isFocus ? R.color.separatorFocus : R.color.separator)
                .frame(height: isFocus ? 2 : 1)
        }
    }
}

class FocusAwareTextField: NSTextField {
    var onFocusChange: (Bool) -> Void = { _ in }

    override func becomeFirstResponder() -> Bool {
        let textView = window?.fieldEditor(true, for: nil) as? NSTextView
        textView?.insertionPointColor = NSColor.systemPink // R.nsColor.action
        onFocusChange(true)
        return super.becomeFirstResponder()
    }
}

struct BorderlessTextField: NSViewRepresentable {
    let placeholder: String
    @Binding var text: String
    @Binding var isFocus: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSTextField {
        let textField = FocusAwareTextField()
        textField.placeholderAttributedString = NSAttributedString(
            string: placeholder,
            attributes: [
                NSAttributedString.Key.foregroundColor: NSColor.gray, // R.nsColor.placeholder
            ]
        )
        textField.isBordered = false
        textField.delegate = context.coordinator
        textField.backgroundColor = NSColor.clear
        textField.textColor = NSColor.green // R.nsColor.text
        textField.font = NSFont(name: "Monaco", size: 20) // R.font.text
        textField.focusRingType = .none
        textField.onFocusChange = { isFocus in
            self.isFocus = isFocus
        }

        return textField
    }

    func updateNSView(_ nsView: NSTextField, context _: Context) {
        nsView.stringValue = text
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: BorderlessTextField

        init(_ textField: BorderlessTextField) {
            parent = textField
        }

        func controlTextDidEndEditing(_: Notification) {
            parent.isFocus = false
        }

        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            parent.text = textField.stringValue
        }
    }
}
