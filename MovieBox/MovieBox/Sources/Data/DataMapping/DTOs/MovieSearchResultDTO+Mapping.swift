//
//  MovieSearchResultDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MovieSearchResultDTO: Decodable {
    let results: [MoviePosterDTO]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
}

extension MovieSearchResultDTO {
    func toDomain() -> MovieSearchResult {
        let results = self.results.map { $0.toDomain() }
        
        return MovieSearchResult(results: results)
    }
}
