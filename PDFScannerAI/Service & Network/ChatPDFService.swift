//
//  © 2025. Brewed with code, ☕, and a sprinkle of innovation. Rights reserved.
//
//  PS: Keep the vibes, respect the rights. 🌟
//

import Foundation
import Alamofire

class ChatPDFService {
    private let uploadURL = "https://api.chatpdf.com/v1/sources/add-file"
    private let chatURL = "https://api.chatpdf.com/v1/chats/message"
    
    func uploadPDF(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in multipartFormData.append(fileURL, withName: "file")},
                  to: uploadURL,
                  headers: ["x-api-key": Constants.pdfApiKey]
        ).responseDecodable(of: UploadResponse.self) { response in
            switch response.result {
            case .success(let uploadResponse):
                completion(.success(uploadResponse.sourceId))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func askQuestion(sourceId: String, question: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = [
            "sourceId": sourceId,
            "messages": [
                [
                    "role": "user",
                    "content": question
                ]
            ]
        ]
        
        AF.request(chatURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["x-api-key": Constants.pdfApiKey, "Content-Type": "application/json"]).responseDecodable(of: ChatResponse.self) { response in
            switch response.result {
            case .success(let chatResponse):
                completion(.success(chatResponse.content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
