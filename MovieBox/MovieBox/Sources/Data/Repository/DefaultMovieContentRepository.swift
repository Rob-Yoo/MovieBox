//
//  DefaultMovieRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation

final class DefaultMovieContentRepository: MovieContentRepository {
    
    private let datasource: MovieContentDataSource
    
    init(datasource: MovieContentDataSource) {
        self.datasource = datasource
    }
    
    func fetchMovieContent(movieID: Int) async -> Result<MovieContent, any Error> {
        async let movieInfo = datasource.fetchMovieInfo(movieID: movieID)
        async let movieCredits = datasource.fetchMovieCredits(movieID: movieID)
        async let movieImageList = datasource.fetchMovieImageList(movieID: movieID)
        async let movieVideoList = datasource.fetchMovieVideoList(movieID: movieID)
        async let similarMovieList = datasource.fetchSimilarMovieList(movieID: movieID)
        async let recommendMovieList = datasource.fetchRecommendMovieList(movieID: movieID)

        do {
            let movieContent = try await MovieContent(
                info: movieInfo.toDomain(),
                credit: movieCredits.toDomain(),
                imageGallery: movieImageList.toDomain(),
                videoGallery: movieVideoList.toDomain(),
                similarMovieGallery: similarMovieList.toDomain(),
                recmdMovieGallery: recommendMovieList.toDomain()
            )
            
            return .success(movieContent)
        } catch {
            return .failure(error)
        }
    }
}
