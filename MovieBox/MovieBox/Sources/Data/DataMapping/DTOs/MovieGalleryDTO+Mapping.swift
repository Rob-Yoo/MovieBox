//
//  MovieGalleryDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MovieGalleryDTO: Decodable {
    let backdrops: [MovieBackdropDTO]
}

struct MovieBackdropDTO: Decodable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

extension MovieGalleryDTO {
    func toDomain() -> MovieContent.MovieImageGallery {
        let list = self.backdrops.map {
            API.tmdbImageRequestBaseUrl + $0.filePath
        }

        return MovieContent.MovieImageGallery(backdropPathList: list)
    }
}
