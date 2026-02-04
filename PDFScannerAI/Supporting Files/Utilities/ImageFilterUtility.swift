import UIKit
import CoreImage

enum ImageFilterType {
    case enhance
    case contrastBW
    case softBW
    case sharpenBW
}

struct ImageFilterUtility {
    static func apply(_ type: ImageFilterType, to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        let context = CIContext(options: nil)
        var output = ciImage

        switch type {
        case .enhance:
            let params: [String: Any] = [
                kCIInputBrightnessKey: 0.05,
                kCIInputContrastKey: 1.1,
                kCIInputSaturationKey: 1.0
            ]
            output = ciImage.applyingFilter("CIColorControls", parameters: params)
        case .contrastBW:
            output = ciImage.applyingFilter("CIPhotoEffectMono")
            output = output.applyingFilter("CIColorControls", parameters: [kCIInputContrastKey: 1.3])
        case .softBW:
            output = ciImage.applyingFilter("CIPhotoEffectTonal")
        case .sharpenBW:
            output = ciImage.applyingFilter("CIPhotoEffectMono")
            output = output.applyingFilter("CISharpenLuminance", parameters: [kCIInputSharpnessKey: 0.7])
        }

        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage)
    }

    static func applyContrastAndBrightness(to image: UIImage, contrast: CGFloat, brightness: CGFloat) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        let context = CIContext(options: nil)
        let params: [String: Any] = [
            kCIInputBrightnessKey: brightness,
            kCIInputContrastKey: contrast,
            kCIInputSaturationKey: 1.0
        ]
        let output = ciImage.applyingFilter("CIColorControls", parameters: params)
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

extension UIImage {
    /// Rotates the image by the given degrees (clockwise).
    func rotated(by degrees: CGFloat) -> UIImage {
        let radians = degrees * CGFloat.pi / 180
        var newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians)).integral.size
        // Prevent odd pixel size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate context
        context.rotate(by: radians)
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}
