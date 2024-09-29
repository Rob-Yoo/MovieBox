//
//  MovieReview.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import Foundation

struct MovieCard {
    let movieID: Int
    let poster: Data?
    let title: String
    var rate: Int
    var comment: String
    let creadedAt: Date
    
    static func makeMovieCard(_ entity: MovieContent.MovieCard) -> Self {
        return MovieCard(
            movieID: entity.movieID,
            poster: entity.poster,
            title: entity.title,
            rate: entity.rate,
            comment: entity.comment,
            creadedAt: entity.createdAt
        )
    }
    
    static func makeMovieCard(movieInfo: MovieContent.MovieInfo) async -> Self {
        
        let result = await ImageLoadManager.shared.loadImageData(from: movieInfo.posterPath)
        var posterData: Data?
        
        switch result {
        case .success(let jpegData):
            posterData = jpegData
        case .failure(let error):
            print(#function, error.localizedDescription)
        }
        
        return MovieCard(
            movieID: movieInfo.id,
            poster: posterData,
            title: movieInfo.title,
            rate: 0,
            comment: "",
            creadedAt: .now
        )
    }
}
