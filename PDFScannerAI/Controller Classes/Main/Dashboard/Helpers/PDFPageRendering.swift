import PDFKit
import UIKit

extension PDFPage {
    /// Renders the PDF page into a UIImage at the provided scale.
    /// - Parameter scale: Image scale factor. Defaults to `3` for high quality.
    /// - Returns: Rendered `UIImage` or `nil` if rendering fails.
    func renderImage(scale: CGFloat = 3.0) -> UIImage? {
        let pageRect = bounds(for: .mediaBox)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: pageRect.size, format: format)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            ctx.cgContext.saveGState()
            // Flip the context because PDF pages use a different coordinate system
            ctx.cgContext.translateBy(x: 0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            draw(with: .mediaBox, to: ctx.cgContext)
            ctx.cgContext.restoreGState()
        }
        return image
    }
}
