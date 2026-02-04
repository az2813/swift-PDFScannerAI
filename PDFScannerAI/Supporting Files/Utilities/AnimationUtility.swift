//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class AnimationUtility {
    
    /// Adds a press animation to a UIButton with a slight shrink effect.
    /// - Parameters:
    ///   - button: The UIButton to animate.
    ///   - completion: A closure to execute after the animation completes.
    static func animateButtonPress(_ button: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform.identity
            }) { _ in
                completion()
            }
        }
    }

    /// Adds a press animation to any UIView with a slight shrink effect.
    /// - Parameters:
    ///   - view: The UIView to animate.
    ///   - completion: A closure to execute after the animation completes.
    static func animateViewPress(_ view: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform.identity
            }) { _ in
                completion()
            }
        }
    }
}
