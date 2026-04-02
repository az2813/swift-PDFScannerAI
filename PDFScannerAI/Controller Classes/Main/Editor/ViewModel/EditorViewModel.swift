//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

enum FilterType {
    case enhance
    case contrastBW
    case softBW
    case sharpenBW
    case original
}

extension FilterType {
    var imageFilter: ImageFilterType {
        switch self {
        case .enhance: return .enhance
        case .contrastBW: return .contrastBW
        case .softBW: return .softBW
        case .sharpenBW: return .sharpenBW
        case .original: return .enhance
        }
    }
}

enum AdjustmentMode { case none, contrast, brightness }

struct PageImage {
    var image: UIImage
    var rotation: Int
    var filter: FilterType
    var filteredImage: UIImage?
}

final class EditorViewModel {
    private(set) var fileName: String = ""
    private(set) var pages: [PageImage] = []
    
    var pageCount: Int {
        pages.count
    }
    
    var adjustmentMode: AdjustmentMode = .none
    var contrastValues: [CGFloat] = []
    var brightnessValues: [CGFloat] = []
    var isFromAddCar: Bool = false
    var isCarImage: Bool = false
    var document: Document? = nil

    func setupAdjustments(for count: Int) {
        contrastValues = Array(repeating: 1.0, count: count)
        brightnessValues = Array(repeating: 0.0, count: count)
    }
    
    func loadImages(_ images: [UIImage]) {
        pages = images.map { PageImage(image: $0, rotation: 0, filter: .original) }
        setupAdjustments(for: pages.count)
        if let document = document {
            fileName = document.fileName
        }
        if fileName.isEmpty {
            if isFromAddCar {
                fileName = "Car_\(DateHelper.fileNameDateString())"
            } else {
                fileName = "Scan_\(DateHelper.fileNameDateString())"
            }
        }
    }
    
    func getImages() -> [UIImage] {
        return pages.map { $0.image }
    }

    private func updateFilteredImage(at index: Int) {
        guard pages.indices.contains(index) else { return }
        if pages[index].filter == .original {
            pages[index].filteredImage = nil
        } else {
            pages[index].filteredImage = ImageFilterUtility.apply(pages[index].filter.imageFilter,
                                                                to: pages[index].image)
        }
    }
    
    func updateFileName(_ newName: String) {
        fileName = newName
    }

    func rotatePage(at index: Int) {
        guard pages.indices.contains(index) else { return }
        pages[index].rotation = (pages[index].rotation + 90) % 360
    }

    func removePage(at index: Int) {
        guard pages.indices.contains(index) else { return }
        pages.remove(at: index)
    }

    func addPages(_ images: [UIImage]) {
        let newPages = images.map { PageImage(image: $0, rotation: 0, filter: .original) }
        pages.append(contentsOf: newPages)
        setupAdjustments(for: pages.count)
    }

    func applyFilter(_ type: FilterType, to index: Int? = nil) {
        if let idx = index, pages.indices.contains(idx) {
            pages[idx].filter = type
            updateFilteredImage(at: idx)
        } else {
            for i in pages.indices {
                pages[i].filter = type
                updateFilteredImage(at: i)
            }
        }
    }

    func getDisplayImage(for index: Int) -> UIImage? {
        guard pages.indices.contains(index) else { return nil }
        let page = pages[index]
        var img = page.image

        if page.filter != .original {
            if page.filteredImage == nil {
                updateFilteredImage(at: index)
            }
            img = page.filteredImage ?? img
        }

        let contrast = getContrast(for: index)
        let brightness = getBrightness(for: index)
        if contrast != 1.0 || brightness != 0.0 || adjustmentMode == .contrast || adjustmentMode == .brightness {
            img = ImageFilterUtility.applyContrastAndBrightness(to: img, contrast: contrast, brightness: brightness)
        }

        if page.rotation != 0 {
            img = img.rotated(by: CGFloat(page.rotation))
        }
        return img
    }
    
    func exportPDF() -> URL? {
        var images: [UIImage] = []
        for i in 0..<pages.count {
            if let img = getDisplayImage(for: i) {
                images.append(img)
            }
        }
        if let document = document {
            return PDFCreator.updatePDF(from: document, images: images)
        } else {
            return PDFCreator.createPDF(from: images, fileName: fileName, isFromAddCar: isFromAddCar)
        }
    }

    func setContrast(_ value: CGFloat, for index: Int) {
        guard contrastValues.indices.contains(index) else { return }
        contrastValues[index] = value
    }
    
    func setBrightness(_ value: CGFloat, for index: Int) {
        guard brightnessValues.indices.contains(index) else { return }
        brightnessValues[index] = value
    }
    
    func getContrast(for index: Int) -> CGFloat {
        contrastValues.indices.contains(index) ? contrastValues[index] : 1.0
    }
    
    func getBrightness(for index: Int) -> CGFloat {
        brightnessValues.indices.contains(index) ? brightnessValues[index] : 0.0
    }
}
