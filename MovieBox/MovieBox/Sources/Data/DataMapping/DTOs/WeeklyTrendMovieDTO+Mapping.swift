//
//  WeeklyTrendMovieDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct WeeklyTrendMovieDTO: Decodable {
    let results: [TrendMovieItemDTO]
}

struct TrendMovieItemDTO: Decodable {
    let id: Int
    let posterPath: String?
    let title: String
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

extension WeeklyTrendMovieDTO {
    func toDomain() -> WeeklyTrendMovieGallery {
        let movieList = self.results.map { $0.toDomain() }
        
        return WeeklyTrendMovieGallery(movieList: movieList)
    }
}

extension TrendMovieItemDTO {
    func toDomain() -> WeeklyTrendMovieGallery.WeeklyTrendMovie {
        let posterPath = API.tmdbImageRequestBaseUrl + (self.posterPath ?? "")
        let releaseYear = DateFormatManager.shared.convertToYearString(format: "yyyy-MM-dd", target: self.releaseDate)
        
        return WeeklyTrendMovieGallery.WeeklyTrendMovie(
            id: self.id,
            posterPath: posterPath,
            name: self.title,
            releaseYear: releaseYear
        )
    }
}
