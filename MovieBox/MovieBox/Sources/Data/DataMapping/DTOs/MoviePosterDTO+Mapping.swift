//
//  MoviePosterDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MoviePosterDTO: Decodable {
    let id: Int
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
    }
}

extension MoviePosterDTO {
    func toDomain() -> MoviePoster {
        let posterPath = API.tmdbImageRequestBaseUrl + (self.posterPath ?? "")
        
        return MoviePoster(id: self.id, posterPath: posterPath)
    }
}
