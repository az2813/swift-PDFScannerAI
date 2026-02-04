//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    var textInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    // MARK: - Initializers

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.textInsets = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        preferredMaxLayoutWidth = bounds.width - (textInsets.left + textInsets.right)
    }

    // MARK: - Padding Setters

    func setPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.textInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    func setHorizontalPadding(_ padding: CGFloat) {
        self.textInsets.left = padding
        self.textInsets.right = padding
    }

    func setVerticalPadding(_ padding: CGFloat) {
        self.textInsets.top = padding
        self.textInsets.bottom = padding
    }
}
