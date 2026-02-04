//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

class KeyboardManager: NSObject {

    weak var view: UIView?
    weak var scrollView: UIScrollView?
    var bottomConstraint: NSLayoutConstraint?
    var onKeyboardChanged: (() -> Void)?
    
    private weak var gestureTarget: UIView?
    
    init(
        view: UIView,
        bottomConstraint: NSLayoutConstraint?,
        scrollView: UIScrollView? = nil,
        gestureTargetView: UIView? = nil
    ) {
        super.init()
        self.view = view
        self.bottomConstraint = bottomConstraint
        self.scrollView = scrollView
        self.gestureTarget = gestureTargetView
        addKeyboardObservers()
        addSwipeGesture()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: Notification) {
        guard let view = view,
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        let safeAreaBottom = view.safeAreaInsets.bottom
        bottomConstraint?.constant = keyboardHeight - safeAreaBottom

        UIView.animate(withDuration: 0.3) {
            view.layoutIfNeeded()
        } completion: { [weak self] _ in
            self?.onKeyboardChanged?()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        bottomConstraint?.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view?.layoutIfNeeded()
        }
    }

    private func addSwipeGesture() {
        guard let target = gestureTarget ?? scrollView else { return }
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeGesture.delegate = self
        target.addGestureRecognizer(swipeGesture)
    }

    @objc private func handleSwipeDown(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: gesture.view)
        if gesture.state == .ended && velocity.y > 1500 {
            view?.endEditing(true)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension KeyboardManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
