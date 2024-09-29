//
//  MovieContentUseCase.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import Foundation

protocol MovieContentUseCase {
    func fetchMovieContent(movieID: Int) async -> Result<MovieContent, Error>
    func saveMovieCard(_ movieCard: MovieContent.MovieCard)
    func updateMovieCard(_ movieCard: MovieContent.MovieCard)
}

final class DefaultMovieContentUseCase: MovieContentUseCase {
    
    private let movieContentRepository: MovieContentRepository
    private let movieBoxRepository: MovieBoxRepository
    
    init(
        movieContentRepository: MovieContentRepository,
        movieBoxRepository: MovieBoxRepository
    ) {
        self.movieContentRepository = movieContentRepository
        self.movieBoxRepository = movieBoxRepository
    }
    
    func fetchMovieContent(movieID: Int) async -> Result<MovieContent, Error> {
        let result = await movieContentRepository.fetchMovieContent(movieID: movieID)
        let movieCard = await fetchMovieCard(movieID: movieID)
        
        switch result {
        case .success(var content):
            content.movieCard = movieCard
            return .success(content)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func saveMovieCard(_ movieCard: MovieContent.MovieCard) {
        movieBoxRepository.createMovieCard(movieCard)
    }
    
    func updateMovieCard(_ movieCard: MovieContent.MovieCard) {
        movieBoxRepository.updateMovieCard(movieCard)
    }
    
    @MainActor
    private func fetchMovieCard(movieID: Int) -> MovieContent.MovieCard? {
        let movieCardList = movieBoxRepository.fetchMovieCardList()
        return movieCardList.first { $0.movieID == movieID }
    }
}
