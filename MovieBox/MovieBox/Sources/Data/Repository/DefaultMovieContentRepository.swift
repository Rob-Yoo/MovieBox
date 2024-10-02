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
    
    func fetchMovieContent(movieID: Int) async -> MovieContent {
        async let movieInfo = (try? datasource.fetchMovieInfo(movieID: movieID)) ?? MovieInfoDTO.defaults()
        async let movieCredits = (try? datasource.fetchMovieCredits(movieID: movieID)) ?? CreditDTO(cast: [])
        async let movieImageList = (try? datasource.fetchMovieImageList(movieID: movieID)) ?? MovieGalleryDTO(backdrops: [])
        async let movieVideoList = (try? datasource.fetchMovieVideoList(movieID: movieID)) ?? MovieVideoDTO(results: [])
        async let similarMovieList = (try? datasource.fetchSimilarMovieList(movieID: movieID)) ?? SimilarMovieDTO(results: [])
        async let recommendMovieList = (try? datasource.fetchRecommendMovieList(movieID: movieID)) ?? RecommendationMovieDTO(results: [])

        let movieContent = await MovieContent(
            info: movieInfo.toDomain(),
            credit: movieCredits.toDomain(),
            imageGallery: movieImageList.toDomain(),
            videoGallery: movieVideoList.toDomain(),
            similarMovieGallery: similarMovieList.toDomain(),
            recmdMovieGallery: recommendMovieList.toDomain()
        )
        
        return movieContent
    }
}
