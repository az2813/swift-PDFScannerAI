//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class FontHelper {
    
    enum FontWeight: String {
        case regular = "Geologica-Thin_Regular"
        case italic = "Geologica-Thin_Italic"
        case thin = "Geologica-Thin"
        case thinItalic = "Geologica-Thin_Thin-Italic"
        
        case extraLight = "Geologica-Thin_ExtraLight"
        case extraLightItalic = "Geologica-Thin_ExtraLight-Italic"
        
        case light = "Geologica-Thin_Light"
        case lightItalic = "Geologica-Thin_Light-Italic"
        
        case medium = "Geologica-Thin_Medium"
        case mediumItalic = "Geologica-Thin_Medium-Italic"
        
        case semiBold = "Geologica-Thin_SemiBold"
        case semiBoldItalic = "Geologica-Thin_SemiBold-Italic"
        
        case bold = "Geologica-Thin_Bold"
        case boldItalic = "Geologica-Thin_Bold-Italic"
        
        case extraBold = "Geologica-Thin_ExtraBold"
        case extraBoldItalic = "Geologica-Thin_ExtraBold-Italic"
        
        case black = "Geologica-Thin_Black"
        case blackItalic = "Geologica-Thin_Black-Italic"
    }

    static func font(_ weight: FontWeight, size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: weight.rawValue, size: size) else {
            fatalError("Failed to load font: \(weight.rawValue)")
        }
        return customFont
    }
}
