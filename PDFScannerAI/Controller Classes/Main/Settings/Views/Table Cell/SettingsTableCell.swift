//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class SettingsTableCell: UITableViewCell {

    @IBOutlet weak var iconHolderView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var optionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        RoundedStyleUtility.apply(
            to: iconHolderView,
            cornerRadius: 12,
            backgroundColor: .clear
        )
        
        optionLabel.textColor = Colors.mainTextColor
        optionLabel.font = FontHelper.font(.medium, size: 16)

        iconImageView.tintColor = Colors.whiteColor
        arrowImageView.tintColor = Colors.navigationItemsTintColor
        contentView.backgroundColor = Colors.secondaryBackgroundColor
    }
    
    func configure(with option: SettingsOption) {
        iconImageView.image = option.icon
        optionLabel.text = option.title
        optionSwitch.isHidden = !option.isToggle

        if option.isToggle {
            optionSwitch.addTarget(self, action: #selector(toggleSwitchChanged), for: .valueChanged)
        }
    }
    
    @objc private func toggleSwitchChanged() {
        let isSwitchOn = optionSwitch.isOn
        print("Switch changed to \(isSwitchOn)")
    }
}
