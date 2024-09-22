//
//  MovieListUseCase.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Foundation

protocol MovieListUseCase {
    func searchMovie(query: String, isPaging: Bool) async -> Result<MovieSearchResult, Error>
    func fetchWeeklyTrendMovieList() async -> Result<WeeklyTrendMovieGallery, Error>
}

final class DefaultMovieListUseCase: MovieListUseCase {
    
    private let movieListRepository: MovieListRepository
    
    init(movieListRepository: MovieListRepository) {
        self.movieListRepository = movieListRepository
    }
    
    func searchMovie(query: String, isPaging: Bool) async -> Result<MovieSearchResult, Error> {
        return await movieListRepository.fetchSearchResult(query: query, isPaging: isPaging)
    }
    
    func fetchWeeklyTrendMovieList() async -> Result<WeeklyTrendMovieGallery, Error> {
        return await movieListRepository.fetchWeeklyTrendMovieList()
    }
}
