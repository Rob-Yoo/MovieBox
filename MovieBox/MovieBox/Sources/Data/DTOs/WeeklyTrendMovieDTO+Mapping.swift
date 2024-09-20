//
//  WeeklyTrendMovieDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct WeeklyTrendMovieDTO: Decodable {
    let results: [MoviePosterDTO]
}

extension WeeklyTrendMovieDTO {
    func toDomain() -> WeeklyTrendMovieGallery {
        let posterList = self.results.map { $0.toDomain() }
        
        return WeeklyTrendMovieGallery(posterList: posterList)
    }
}
