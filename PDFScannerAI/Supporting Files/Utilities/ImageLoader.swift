//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

/// Helper utility to load and cache downsampled images.
class ImageLoader {
    static func loadImage(data: Data?, uid: String?, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        guard let uid = uid, let data = data else {
            completion(nil)
            return
        }

        if let cached = ImageCacheManager.shared.image(forKey: uid) {
            completion(cached)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let image = UIImage.downsample(imageData: data, to: targetSize)
            if let image = image {
                ImageCacheManager.shared.setImage(image, forKey: uid)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }

    /// Load original quality image and cache it.
    static func loadOriginalImage(data: Data?, uid: String?, completion: @escaping (UIImage?) -> Void) {
        guard let uid = uid, let data = data else {
            completion(nil)
            return
        }

        let cacheKey = "orig_" + uid
        if let cached = ImageCacheManager.shared.image(forKey: cacheKey) {
            completion(cached)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let image = UIImage(data: data)
            if let image = image {
                ImageCacheManager.shared.setImage(image, forKey: cacheKey)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
