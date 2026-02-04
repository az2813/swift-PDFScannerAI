//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class RoundedStyleUtility {
    static func apply(
        to view: UIView,
        cornerRadius: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        titleTextColor: UIColor? = nil
    ) {
        if let cornerRadius = cornerRadius {
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor
        }
        
        if let tintColor = tintColor, let button = view as? UIButton {
            button.tintColor = tintColor
        }
        
        if let borderColor = borderColor {
            view.layer.borderColor = borderColor.cgColor
        }
        
        if let borderWidth = borderWidth {
            view.layer.borderWidth = borderWidth
        }
        
        if let titleTextColor = titleTextColor, let button = view as? UIButton {
            button.setTitleColor(titleTextColor, for: .normal)
        }
    }
}
