//
//  DefaultMovieBoxRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import Foundation

final class DefaultMovieBoxRepository: MovieBoxRepository {
    
    private let dataSource: MovieBoxDataSource
    
    init(dataSource: MovieBoxDataSource) {
        self.dataSource = dataSource
    }
    
    func createMovieCard(_ movieCard: MovieContent.MovieCard) {
        dataSource.createMovieCard(movieCard)
    }
    
    func fetchMovieCardList() -> [MovieContent.MovieCard] {
        let movieCardList = dataSource.fetchMovieCardList()
        
        return movieCardList.map { movieCard, imageData in
            MovieContent.MovieCard(
                movieID: movieCard.id,
                poster: imageData,
                title: movieCard.title,
                rate: movieCard.rate,
                comment: movieCard.comment,
                createdAt: movieCard.createdAt
            )
        }
    }
    
    func updateMovieCard(_ movieCard: MovieContent.MovieCard) {
        dataSource.updateMovieCard(movieCard)
    }
    
    func deleteMovieCard(movieID: Int) {
        dataSource.deleteMovieCard(movieID: movieID)
    }
    
    
}
