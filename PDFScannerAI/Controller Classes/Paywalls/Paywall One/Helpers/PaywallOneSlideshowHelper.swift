//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class PaywallOneSlideshowHelper {
	private weak var imageView: UIImageView?
	private var images: [UIImage] = []
	private var timer: Timer?
	private var currentIndex: Int = 0

	private let slideInterval: TimeInterval
	private let crossfadeDuration: TimeInterval

	init(
		imageView: UIImageView,
		imageNames: [String],
		slideInterval: TimeInterval = 2.75,
		crossfadeDuration: TimeInterval = 0.8
	) {
		self.imageView = imageView
		self.slideInterval = slideInterval
		self.crossfadeDuration = crossfadeDuration
		self.images = imageNames.compactMap { UIImage(named: $0) }

		NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
		stop()
	}

	func start() {
		guard timer == nil, images.count > 1, let imageView else { return }
		currentIndex = 0
		imageView.image = images[currentIndex]
		imageView.alpha = 1.0
		timer = Timer.scheduledTimer(withTimeInterval: slideInterval, repeats: true, block: { [weak self] _ in
			self?.showNextSlide()
		})
		RunLoop.main.add(timer!, forMode: .common)
	}

	func stop() {
		timer?.invalidate()
		timer = nil
	}

	@objc private func appWillResignActive() {
		stop()
	}

	@objc private func appDidBecomeActive() {
		start()
	}

	private func showNextSlide() {
		guard let imageView else { return }
		guard images.count > 1 else { return }
		currentIndex = (currentIndex + 1) % images.count
		let nextImage = images[currentIndex]

		let fadeOutDuration = crossfadeDuration * 0.45
		let fadeInDuration = crossfadeDuration * 0.55
		UIView.animate(withDuration: fadeOutDuration, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
			imageView.alpha = 0
		} completion: { _ in
			imageView.image = nextImage
			UIView.animate(withDuration: fadeInDuration, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
				imageView.alpha = 1
			}
		}
	}
}


