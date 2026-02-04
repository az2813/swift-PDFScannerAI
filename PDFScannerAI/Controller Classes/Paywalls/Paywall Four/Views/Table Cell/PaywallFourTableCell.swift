//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PaywallFourTableCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var priceTrialLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        holderView.layer.cornerRadius = holderView.frame.height/2
    }

    // MARK: - UI Setup
    private func setupUI() {
        holderView.layoutIfNeeded()
        RoundedStyleUtility.apply(
            to: holderView,
            cornerRadius: holderView.frame.height/2
        )

        durationLabel.font = FontHelper.font(.bold, size: 18)
        priceTrialLabel.font = FontHelper.font(.medium, size: 16)
        priceLabel.font = FontHelper.font(.bold, size: 18)

        applyUnselectedStyle()
    }

    private func applyUnselectedStyle() {
        holderView.backgroundColor = Colors.secondaryBackgroundColor
        holderView.layer.borderColor = Colors.strokeColor.cgColor
        holderView.layer.borderWidth = 1.0
        setLabelColors(duration: Colors.mainTextColor, priceTrial: Colors.secondaryTextColor, price: Colors.mainTextColor)
    }

    private func applySelectedStyle() {
        holderView.backgroundColor = Colors.blueColor
        holderView.layer.borderColor = Colors.whiteColor.cgColor
        holderView.layer.borderWidth = 0.0
        setLabelColors(duration: Colors.whiteColor, priceTrial: Colors.whiteColor, price: Colors.whiteColor)
    }

    private func setLabelColors(duration: UIColor, priceTrial: UIColor, price: UIColor) {
        durationLabel.textColor = duration
        priceTrialLabel.textColor = priceTrial
        priceLabel.textColor = price
    }

    // MARK: - State
    func setSelectedState(isSelected: Bool) {
        if isSelected {
            applySelectedStyle()
        } else {
            applyUnselectedStyle()
        }
    }

    // MARK: - Configuration
    func configure(duration: String, priceTrial: String, priceOnly: String) {
        durationLabel.text = duration
        priceTrialLabel.text = priceTrial
        priceLabel.text = priceOnly
    }
}
