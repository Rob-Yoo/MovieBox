//
//  MovieInfo.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import Foundation

struct MovieInfo {
    let backdropPath: String
    let posterPath: String
    let title: String
    private let releaseYear: String
    private let country: String
    private let genres: String
    let overview: String
    let runTime: String
    
    var subHeadlineInfo: String {
        if (releaseYear.isEmpty) {
            return ""
        }
        return "\(releaseYear) • \(country) • \(genres)"
    }
    
    init(backdropPath: String = "",
         posterPath: String  = "",
         title: String = "",
         releaseYear: String = "",
         country: String = "",
         genres: String = "",
         overview: String = "",
         runTime: String = ""
    ) {
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.title = title
        self.releaseYear = releaseYear
        self.country = country
        self.genres = genres
        self.overview = overview
        self.runTime = runTime
    }
    
    static func makeModel(_ entity: MovieContent.MovieInfo) -> Self {
        let genres = entity.genres.joined(separator: "/")
        let runtime = makeRuntimeString(entity.runtime)
        let country = entity.country.joined(separator: "/")

        return MovieInfo(
            backdropPath: entity.backdropPath,
            posterPath: entity.posterPath,
            title: entity.title,
            releaseYear: entity.releaseYear,
            country: country,
            genres: genres,
            overview: entity.overview,
            runTime: runtime
        )
    }
    
    private static func makeRuntimeString(_ time: Int) -> String {
        if (time >= 60) {
            return (time % 60 == 0) ? "\(time / 60)시간" : "\(time / 60)시간 \(time % 60)분"
        } else {
            return "\(time % 60)분"
        }
    }
}


