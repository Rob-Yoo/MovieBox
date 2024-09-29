//
//  ImageLoadManager.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import Foundation
import Nuke

final class ImageLoadManager {
    static let shared = ImageLoadManager()
    
    func loadImageData(from urlString: String) async -> Result<Data, Error> {
        guard let url = URL(string: urlString) else {
            return .failure(URLError(.badURL))
        }
        
        let request = ImageRequest(url: url)
        
        do {
            let response = try await withCheckedThrowingContinuation { continuation in
                Nuke.ImagePipeline.shared.loadImage(with: request) { result in
                    switch result {
                    case .success(let response):
                        continuation.resume(returning: response)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            if let jpegData = response.image.jpegData(compressionQuality: 0.8) {
                return .success(jpegData)
            } else {
                return .failure(URLError(.cannotDecodeContentData))
            }
        } catch {
            return .failure(error)
        }
    }
}
