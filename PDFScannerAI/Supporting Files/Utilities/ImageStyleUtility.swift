//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class ImageStyleUtility {
    static func apply(
        to view: UIButton,
        imageName: String? = nil,
        title: String? = nil,
        cornerRadius: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        tintColor: UIColor? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        titleTextColor: UIColor? = nil
    ) {
        if let imageName = imageName {
            let image = UIImage(named: imageName)
            var config = UIButton.Configuration.plain()
            if let title = title {
                config.title = title
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = FontHelper.font(.bold, size: 16)
                    outgoing.foregroundColor = titleTextColor ?? view.titleColor(for: .normal)
                    return outgoing
                }
            }
            config.image = image
            config.imagePlacement = .top
            config.imagePadding = 4

            view.configuration = config
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if let cornerRadius = cornerRadius {
            view.layer.cornerRadius = cornerRadius
            view.layer.masksToBounds = true
        }
        
        if let backgroundColor = backgroundColor {
            view.backgroundColor = backgroundColor
        }
        
        if let tintColor = tintColor {
            view.tintColor = tintColor
        }
        
        if let borderColor = borderColor {
            view.layer.borderColor = borderColor.cgColor
        }
        
        if let borderWidth = borderWidth {
            view.layer.borderWidth = borderWidth
        }
    }
}
