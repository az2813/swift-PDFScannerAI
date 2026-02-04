//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class PlaceholderManager {
    static func apply(to textView: UITextView, placeholder: String, color: UIColor) {
        textView.text = placeholder
        textView.textColor = color
    }

    static func clearIfNeeded(_ textView: UITextView, placeholder: String, placeholderColor: UIColor, activeColor: UIColor) {
        if textView.text == placeholder && textView.textColor == placeholderColor {
            textView.text = ""
            textView.textColor = activeColor
        }
    }

    static func restoreIfNeeded(_ textView: UITextView, placeholder: String, placeholderColor: UIColor) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            apply(to: textView, placeholder: placeholder, color: placeholderColor)
        }
    }

    static func isPlaceholderVisible(_ textView: UITextView, placeholder: String, placeholderColor: UIColor) -> Bool {
        return textView.text == placeholder && textView.textColor == placeholderColor
    }
}
