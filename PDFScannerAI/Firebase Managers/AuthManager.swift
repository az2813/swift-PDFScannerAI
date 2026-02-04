//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()

    private init() {}

    func getCurrentUserUID(completion: @escaping (Result<String, Error>) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            completion(.success(uid))
        } else {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = authResult?.user {
                    completion(.success(user.uid))
                }
            }
        }
    }
}
