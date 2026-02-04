//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallThreeTableCell: UITableViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        holderView.layer.cornerRadius = 20
    }

    // MARK: - UI Setup
    private func setupUI() {
        RoundedStyleUtility.apply(
            to: holderView,
            cornerRadius: 20
        )

        applyUnselectedStyle()

        durationLabel.font = FontHelper.font(.medium, size: 16)
        priceLabel.font = FontHelper.font(.bold, size: 20)
        trialLabel.font = FontHelper.font(.medium, size: 14)
        productDescriptionLabel.font = FontHelper.font(.regular, size: 14)
        productDescriptionLabel.numberOfLines = 0
        trialLabel.textColor = Colors.greenColor
    }

    private func applyUnselectedStyle() {
        holderView.backgroundColor = Colors.secondaryBackgroundColor
        holderView.layer.borderColor = Colors.strokeColor.cgColor
        holderView.layer.borderWidth = 1.0
        setLabelColors(Colors.mainTextColor, secondary: Colors.secondaryTextColor)
    }

    private func applySelectedStyle() {
        holderView.backgroundColor = Colors.secondaryBackgroundColor
        holderView.layer.borderColor = Colors.blueColor.cgColor
        holderView.layer.borderWidth = 2.0
        setLabelColors(Colors.mainTextColor, secondary: Colors.secondaryTextColor)
    }

    private func setLabelColors(_ main: UIColor, secondary: UIColor) {
        durationLabel.textColor = main
        priceLabel.textColor = main
        productDescriptionLabel.textColor = main
        trialLabel.textColor = Colors.greenColor
    }

    // MARK: - State
    func setSelectedState(isSelected: Bool) {
        if isSelected {
            applySelectedStyle()
        } else {
            applyUnselectedStyle()
        }
        selectImageView.image = UIImage(named: isSelected ? "selected_image" : "deselected_image")
    }

    // MARK: - Configuration
    func configure(price: String, duration: String, trial: String, description: String) {
        priceLabel.text = price
        durationLabel.text = duration
        trialLabel.text = trial
        productDescriptionLabel.text = description
    }
}
