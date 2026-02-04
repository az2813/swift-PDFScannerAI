//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class GradientUtility {
    static func applyGradient(to label: UILabel, withColors colors: [CGColor], fontSize: CGFloat = 34, fontWeight: UIFont.Weight = .bold) {
        guard label.bounds.size != .zero else { return }
        
        label.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = label.bounds

        UIGraphicsBeginImageContext(label.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        gradientLayer.render(in: context)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        label.textColor = UIColor(patternImage: gradientImage ?? UIImage())
    }
}
