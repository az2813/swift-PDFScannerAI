//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import UIKit

struct ChatDisplayMessage {
    enum MessageType {
        case user
        case ai
    }

    let type: MessageType
    let text: String
    var image: UIImage?

    init(type: MessageType, text: String, image: UIImage? = nil) {
        self.type = type
        self.text = text
        self.image = image
    }
}
