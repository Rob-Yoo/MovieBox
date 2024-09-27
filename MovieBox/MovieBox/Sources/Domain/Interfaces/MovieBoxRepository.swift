//
//  MovieBoxRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import Foundation

protocol MovieBoxRepository {
    func createMovieCard(_ movieCard: MovieContent.MovieCard)
    func fetchMovieCardList() -> [MovieContent.MovieCard]
    func updateMovieCard(_ movieCard: MovieContent.MovieCard)
    func deleteMovieCard(movieID: Int)
}
