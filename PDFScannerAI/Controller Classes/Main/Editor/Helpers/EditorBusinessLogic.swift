//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

final class EditorBusinessLogic {
    private let viewModel: EditorViewModel
    
    init(viewModel: EditorViewModel) {
        self.viewModel = viewModel
    }
    
    var pageCount: Int { viewModel.pageCount }
    var fileName: String { viewModel.fileName }
    
    func loadImages(_ images: [UIImage]) {
        viewModel.loadImages(images)
    }
    
    func updateFileName(_ newName: String) {
        viewModel.updateFileName(newName)
    }
    
    func applyFilter(_ type: FilterType, at index: Int) {
        viewModel.applyFilter(type, to: index)
    }
    
    func rotatePage(at index: Int) {
        viewModel.rotatePage(at: index)
    }
    
    func removePage(at index: Int) {
        viewModel.removePage(at: index)
    }
    
    func addPages(_ images: [UIImage]) {
        viewModel.addPages(images)
    }
    
    func displayImage(for index: Int) -> UIImage? {
        viewModel.getDisplayImage(for: index)
    }
    
    func exportPDF() -> URL? {
        viewModel.exportPDF()
    }
}
