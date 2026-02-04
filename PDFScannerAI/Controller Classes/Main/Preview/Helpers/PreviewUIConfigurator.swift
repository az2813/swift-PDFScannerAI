//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit
import PDFKit

final class PreviewUIConfigurator {
    static let defaultMainContainerViewHeight: CGFloat = 88.0
    static let maxInputTextViewHeight: CGFloat = 160.0
    static let minInputTextViewHeight: CGFloat = 56.0
    static let placeholderText = "Ask me anything..."
    static let placeholderTextColor = Colors.secondaryTextColor

    private weak var viewController: PreviewViewController?

    init(viewController: PreviewViewController) {
        self.viewController = viewController
    }

    func configureUI() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = Colors.backgroundColor
        
        RoundedStyleUtility.apply(to: vc.switcherView, cornerRadius: 16, backgroundColor: Colors.secondaryBackgroundColor)
        RoundedStyleUtility.apply(to: vc.fileButton, cornerRadius: 14, backgroundColor: Colors.blueColor, titleTextColor: Colors.whiteColor)
        RoundedStyleUtility.apply(to: vc.chatsButton, cornerRadius: 14, backgroundColor: Colors.blueColor, titleTextColor: Colors.whiteColor)
        vc.fileButton.alpha = 1.0
        vc.chatsButton.alpha = 0.2

        RoundedStyleUtility.apply(to: vc.messageContainer, cornerRadius: vc.messageContainer.frame.height/2, backgroundColor: .clear, borderColor: Colors.strokeColor, borderWidth: 2.0)
        
        RoundedStyleUtility.apply(to: vc.sendButton, cornerRadius: vc.sendButton.frame.height/2, backgroundColor: Colors.blueColor, tintColor: Colors.whiteColor)
        vc.sendButton.isEnabled = false
        vc.sendButton.alpha = 0.5

        vc.bottomHolderView.backgroundColor = Colors.whiteColor
        vc.bottomHolderView.layer.cornerRadius = 30
        vc.bottomHolderView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vc.bottomHolderView.clipsToBounds = false

        vc.bottomSupportView.backgroundColor = Colors.whiteColor
        if !hasNotch() {
            vc.bottomSupportView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        PlaceholderManager.apply(to: vc.inputTextView, placeholder: PreviewUIConfigurator.placeholderText, color: PreviewUIConfigurator.placeholderTextColor)
        vc.inputTextView.delegate = vc
        vc.messageContainerViewHeightConstraint.constant = PreviewUIConfigurator.defaultMainContainerViewHeight
        
        vc.inputTextView.font = FontHelper.font(.medium, size: 16)

        vc.keyboardManager = KeyboardManager(view: vc.view, bottomConstraint: vc.bottomConstraint, gestureTargetView: vc.view)
        vc.keyboardManager?.onKeyboardChanged = { [weak vc] in
            vc?.updateMessageContainerHeight()
        }

        configurePDFView()
    }

    private func hasNotch() -> Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets.bottom > 0
        }
        return false
    }

    private func configurePDFView() {
        guard let vc = viewController, let document = vc.viewModel.pdfDocument else { return }
        vc.pdfView?.removeFromSuperview()
        let pdfView = PDFView(frame: vc.contentHolderView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        pdfView.document = document
        vc.contentHolderView.insertSubview(pdfView, at: 0)
        vc.pdfView = pdfView
    }
}
