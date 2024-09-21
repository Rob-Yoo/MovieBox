//
//  SimilarMovieDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct SimilarMovieDTO: Decodable {
    let results: [MoviePosterDTO]
}

extension SimilarMovieDTO {
    func toDomain() -> SimilarMovieGallery {
        let posterList = self.results.map { $0.toDomain() }

        return SimilarMovieGallery(posterList: posterList)
    }
}


