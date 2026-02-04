//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation

struct UploadResponse: Codable {
    let sourceId: String
}

struct ChatResponse: Codable {
    let content: String
    let references: [Reference]?
    
    struct Reference: Codable {
        let pageNumber: Int
    }
}
