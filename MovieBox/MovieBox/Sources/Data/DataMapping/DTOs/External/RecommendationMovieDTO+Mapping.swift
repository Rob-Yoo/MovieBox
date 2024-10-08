//
//  RecommendationMovieDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct RecommendationMovieDTO: Decodable {
    let results: [MoviePosterDTO]
}

extension RecommendationMovieDTO {
    func toDomain() -> MovieContent.RecommendationMovieGallery {
        let posterList = self.results.map { $0.toDomain() }
        
        return MovieContent.RecommendationMovieGallery(posterList: posterList)
    }
}
