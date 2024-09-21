//
//  MovieDetailDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MovieInfoDTO: Decodable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let genres: [GenreDTO]
    let country: [String]
    let overview: String?
    let releaseDate: String
    let runtime: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, genres, overview, runtime
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case country = "origin_country"
        case releaseDate = "release_date"
    }
}

struct GenreDTO: Decodable {
    let name: String
}

extension MovieInfoDTO {
    func toDomain() -> MovieContent.MovieInfo {
        let genres = self.genres.map { $0.name }
        let country = self.country.map { CountryMapper.covertToName(code: $0) }
        let posterPath = API.tmdbImageRequestBaseUrl + (self.posterPath ?? "")
        let backdropPath = API.tmdbImageRequestBaseUrl + (self.backdropPath ?? "")
        
        return MovieContent.MovieInfo(
            id: self.id,
            posterPath: posterPath,
            backdropPath: backdropPath,
            genres: genres,
            country: country,
            title: self.title,
            runtime: self.runtime,
            overview: self.overview ?? "",
            releaseDate: self.releaseDate
        )
    }
}
