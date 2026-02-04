//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class TextViewHeightManager {
    static func adjustHeight(for textView: UITextView, minHeight: CGFloat, maxHeight: CGFloat, defaultHeight: CGFloat, padding: CGFloat = 16) -> CGFloat {
        let contentHeight = max(textView.contentSize.height, minHeight)
        return max(defaultHeight, min(contentHeight + padding, maxHeight))
    }
}
