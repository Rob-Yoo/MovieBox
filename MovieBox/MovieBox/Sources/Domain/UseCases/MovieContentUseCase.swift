//
//  MovieContentUseCase.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import Foundation

protocol MovieContentUseCase {
    func fetchMovieContent(movieID: Int) async -> Result<MovieContent, Error>
}

final class DefaultMovieContentUseCase: MovieContentUseCase {
    
    private let movieContentRepository: MovieContentRepository
    
    init(movieContentRepository: MovieContentRepository) {
        self.movieContentRepository = movieContentRepository
    }
    
    func fetchMovieContent(movieID: Int) async -> Result<MovieContent, any Error> {
        let result = await movieContentRepository.fetchMovieContent(movieID: movieID)
        
        switch result {
        case .success(let content):
            return .success(content)
        case .failure(let error):
            return .failure(error)
        }
    }
}
