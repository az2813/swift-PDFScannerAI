//
//  PaywallCollectionCell.swift
//  PDFScannerAI
//
//  Created by dev on 26.02.2026.
//

import UIKit

class PaywallTermCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var selection: Bool = false {
        didSet {
            if selection {
                containerView.layer.borderColor = Colors.blueColor.cgColor
                selectedImageView.isHidden = false
            } else {
                containerView.layer.borderColor = Colors.grayColor.cgColor
                selectedImageView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        termLabel.font = FontHelper.font(.regular, size: 14)
        priceLabel.font = FontHelper.font(.bold, size: 18)
        saveLabel.font = FontHelper.font(.regular, size: 12)
        periodLabel.font = FontHelper.font(.regular, size: 14)
        RoundedStyleUtility.apply(to: containerView, cornerRadius: 12.0, backgroundColor: Colors.whiteColor, borderColor: Colors.grayColor, borderWidth: 2.0)
        RoundedStyleUtility.apply(to: saveLabel, cornerRadius: 12.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedImageView.layer.cornerRadius = selectedImageView.frame.width / 2.0
        selectedImageView.layer.masksToBounds = true
        selectedImageView.backgroundColor = .white
    }
}
