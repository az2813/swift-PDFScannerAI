//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class LoadingIndicatorManager {
    static let shared = LoadingIndicatorManager()
    
    private var blurEffectView: UIVisualEffectView?
    private var spinnerImageView: UIImageView?
    
    private init() {}

    func setup(for view: UIView, navigationController: UINavigationController? = nil) {
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = UIScreen.main.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.isHidden = true

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(blurEffectView!)
        } else if let navigationController = navigationController {
            navigationController.view.addSubview(blurEffectView!)
        } else {
            view.addSubview(blurEffectView!)
        }

        spinnerImageView = UIImageView(image: UIImage(named: "spinner_image"))
        spinnerImageView?.contentMode = .scaleAspectFit
        spinnerImageView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        spinnerImageView?.center = UIScreen.main.bounds.center
        blurEffectView?.contentView.addSubview(spinnerImageView!)
    }

    func show() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.blurEffectView?.isHidden = false
            self.startRotatingSpinner()
        }
    }

    func hide() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.blurEffectView?.isHidden = true
            self.stopRotatingSpinner()
        }
    }

    func cleanup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.blurEffectView?.removeFromSuperview()
            self.spinnerImageView?.removeFromSuperview()
            self.blurEffectView = nil
            self.spinnerImageView = nil
        }
    }

    // MARK: - Spinner Animation
    private func startRotatingSpinner() {
        guard let spinner = spinnerImageView else { return }
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 1.2
        rotationAnimation.repeatCount = .infinity
        spinner.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopRotatingSpinner() {
        spinnerImageView?.layer.removeAnimation(forKey: "rotationAnimation")
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
