//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class TextViewUtility {
    static func centerVerticalText(in textView: UITextView) {
        var topInset = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topInset = max(0, topInset)
        textView.contentInset.top = topInset
    }
}
