//
//  MovieSearchResultDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MovieSearchResultDTO: Decodable {
    let results: [MoviePosterDTO]
}

extension MovieSearchResultDTO {
    func toDomain() -> MovieSearchResult {
        let results = self.results.map { $0.toDomain() }
        
        return MovieSearchResult(results: results)
    }
}
