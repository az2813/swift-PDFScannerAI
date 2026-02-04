//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class PremiumTableCell: UITableViewCell {

    @IBOutlet weak var giftIcon: UIImageView!
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var premiumSubtitleLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    private var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        setupBackgroundImageView()
        
        giftIcon.tintColor = Colors.whiteColor
        
        arrowIcon.tintColor = Colors.whiteColor
        
        premiumTitleLabel.textColor = Colors.whiteColor
        premiumSubtitleLabel.textColor = Colors.whiteColor
        
        premiumTitleLabel.font = FontHelper.font(.bold, size: 18)
        premiumSubtitleLabel.font = FontHelper.font(.semiBold, size: 14)
        
        premiumTitleLabel.text = "Premium for free"
        premiumSubtitleLabel.text = "Create stunning AI tattoos with no limits"
    }
    
    private func setupBackgroundImageView() {
        backgroundImageView = UIImageView(frame: contentView.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.clipsToBounds = true
        
        backgroundImageView.image = UIImage(named: "gradient_2_image")
        
        contentView.insertSubview(backgroundImageView, at: 0)
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    
    /// Sets a custom background image for the cell
    /// - Parameter imageName: The name of the image in the asset catalog
    func setBackgroundImage(_ imageName: String) {
        backgroundImageView.image = UIImage(named: imageName)
    }
    
    /// Removes the background image and shows a solid color background
    /// - Parameter color: The background color to use
    func removeBackgroundImage(withColor color: UIColor = Colors.secondaryBackgroundColor) {
        backgroundImageView.image = nil
        contentView.backgroundColor = color
    }
}
