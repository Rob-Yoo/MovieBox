//
//  MovieListRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation

protocol MovieListRepository {
    func fetchSearchResult(query: String, isPaging: Bool) async -> Result<MovieSearchResult, Error>
//    func fetchDailyBoxOfficeList() async throws -> DailyBoxOfficeGallery
    func fetchWeeklyTrendMovieList() async -> Result<WeeklyTrendMovieGallery, Error>
}
