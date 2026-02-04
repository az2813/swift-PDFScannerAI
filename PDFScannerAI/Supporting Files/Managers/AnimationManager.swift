//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class AnimationManager {
    static func animateElements(_ elements: [UIView]) {
        for (index, element) in elements.enumerated() {
            element.alpha = 0
            element.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            UIView.animate(withDuration: 0.6,
                           delay: Double(index) * 0.15,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut,
                           animations: {
                element.alpha = 1
                element.transform = .identity
            }, completion: nil)
        }
    }
}
