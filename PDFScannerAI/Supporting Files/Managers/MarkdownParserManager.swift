//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit
import CDMarkdownKit

class MarkdownParserManager {
    static let shared = MarkdownParserManager()

    private let parser: CDMarkdownParser

    private init() {
        let regularFont = FontHelper.font(.medium, size: 16)
        let boldFont = FontHelper.font(.bold, size: 16)
        let italicFont = FontHelper.font(.light, size: 16)

        parser = CDMarkdownParser(
            font: regularFont,
            boldFont: boldFont,
            italicFont: italicFont,
            fontColor: Colors.mainTextColor,
            backgroundColor: .clear,
            squashNewlines: false
        )

        parser.bold.color = Colors.mainTextColor
        parser.italic.color = Colors.mainTextColor
        parser.header.color = Colors.mainTextColor
        parser.quote.color = Colors.mainTextColor
        parser.code.color = Colors.mainTextColor
        parser.link.color = Colors.blueColor
    }

    func parse(_ markdown: String) -> NSAttributedString {
        return parser.parse(markdown)
    }
}
