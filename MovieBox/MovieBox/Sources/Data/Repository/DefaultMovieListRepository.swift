//
//  DefaultMovieListRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Foundation

final class DefaultMovieListRepository: MovieListRepository {
    
    private var dataSource: MovieListDataSource
    
    init(dataSource: MovieListDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchSearchResult(query: String, isPaging: Bool) async -> Result<MovieSearchResult, Error> {
        let result = await dataSource.fetchSearchResult(query: query, isPaging: isPaging)
        
        switch result {
        case .success(let dto):
            return .success(dto.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
        
    func fetchWeeklyTrendMovieList() async -> Result<WeeklyTrendMovieGallery, Error> {
        let result = await dataSource.fetchWeeklyTrendMovieList()
        
        switch result {
        case .success(let dto):
            return .success(dto.toDomain())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    
}
