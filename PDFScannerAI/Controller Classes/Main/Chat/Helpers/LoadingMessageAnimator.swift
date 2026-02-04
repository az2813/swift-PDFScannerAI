//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import UIKit

class LoadingMessageAnimator {
    
    private var timer: Timer?
    private var typewriterTimer: Timer?

    private var index = 0
    private var currentText = ""
    private var fullText = ""
    private var characterIndex = 0

    private let statusTexts = [
        "Hmm... let me take a look",
        "Thinking it through...",
        "Working on it...",
        "Almost done! Just a sec...",
        "Got it! Preparing your results..."
    ]

    /// Starts the loading animation with typewriter effect.
    func startAnimating(updateCell: @escaping (String) -> Void) {
        index = Int.random(in: 0..<statusTexts.count)
        scheduleNextStatus(updateCell: updateCell)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { [weak self] _ in
            self?.scheduleNextStatus(updateCell: updateCell)
        }
    }

    private func scheduleNextStatus(updateCell: @escaping (String) -> Void) {
        fullText = statusTexts[index]
        currentText = ""
        characterIndex = 0

        typewriterTimer?.invalidate()
        typewriterTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard self.characterIndex < self.fullText.count else {
                self.typewriterTimer?.invalidate()
                return
            }

            let char = self.fullText[self.characterIndex]
            self.currentText.append(char)
            updateCell(self.currentText)
            self.characterIndex += 1
        }

        index = (index + 1) % statusTexts.count
    }

    /// Returns a random initial message (for static assignment).
    func randomInitialStatus() -> String {
        return statusTexts.randomElement() ?? "Загружаюсь..."
    }

    func stopAnimating() {
        timer?.invalidate()
        timer = nil
        typewriterTimer?.invalidate()
        typewriterTimer = nil
    }
}

private extension String {
    subscript(index: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: index)]
    }
}
