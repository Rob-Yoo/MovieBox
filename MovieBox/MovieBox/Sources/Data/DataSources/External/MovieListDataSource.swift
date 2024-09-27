//
//  MovieListDataSource.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Foundation
import Moya

protocol MovieListDataSource {
    func fetchSearchResult(query: String, isPaging: Bool) async -> Result<MovieSearchResultDTO, Error>
//    func fetchDailyBoxOfficeList() async throws -> BoxOfficeDTO
    func fetchWeeklyTrendMovieList() async -> Result<WeeklyTrendMovieDTO, Error>
}

final class DefaultMovieListDataSource: MovieListDataSource {
    
    private let tmdbProvider = MoyaProvider<TMDBRequest>()
//    private let kobisProvider = MoyaProvider<KobisRequest>()
    private var page = 1
    private var totalPages = 1
    
    func fetchSearchResult(query: String, isPaging: Bool) async -> Result<MovieSearchResultDTO, Error> {
        guard page <= totalPages else {
            return .success(MovieSearchResultDTO(results: [], totalPages: 0))
        }
        
        page = isPaging ? (page + 1) : 1
        
        let result = await tmdbProvider.request(.searchMovie(query: query, page: page))
        
        switch result {
        case .success(let data):
            let mapResult = data.mapResult(MovieSearchResultDTO.self)
            
            switch mapResult {
            case .success(let dto):
                totalPages = dto.totalPages
                return .success(dto)
            case .failure(let error):
                return .failure(error)
            }

        case .failure(let error):
            return .failure(error)
        }
    }
    
    /* func fetchDailyBoxOfficeList() async throws -> BoxOfficeDTO {
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let result = await kobisProvider.request(.dailyBoxOffice(date: yesterDay))
        
        switch result {
        case .success(let response):
            return try response.map(BoxOfficeDTO.self)
        case .failure(let error):
            throw error
        }
    } */
    
    func fetchWeeklyTrendMovieList() async -> Result<WeeklyTrendMovieDTO, Error> {
        let result = await tmdbProvider.request(.weeklyTrendMovies)
        
        switch result {
        case .success(let response):
            let mapResult = response.mapResult(WeeklyTrendMovieDTO.self)
            return mapResult
        case .failure(let error):
            return .failure(error)
        }
    }
}
