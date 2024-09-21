//
//  MovieContentDataSource.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Moya

protocol MovieContentDataSource {
    func fetchMovieInfo(movieID: String) async throws -> MovieInfoDTO
    func fetchSimilarMovieList(movieID: String) async throws -> SimilarMovieDTO
    func fetchRecommendMovieList(movieID: String) async throws -> RecommendationMovieDTO
    func fetchMovieVideoList(movieID: String) async throws -> MovieVideoDTO
    func fetchMovieImageList(movieID: String) async throws -> MovieGalleryDTO
    func fetchMovieCredits(movieID: String) async throws -> CreditDTO
}

final class DefaultMovieContentDataSource: MovieContentDataSource {
    private let provider = MoyaProvider<TMDBRequest>()
    
    func fetchMovieInfo(movieID: String) async throws -> MovieInfoDTO {
        let result = await provider.request(.movieInfo(movieID))
        
        return try decapsulateResponse(result: result, type: MovieInfoDTO.self)
    }
    
    func fetchSimilarMovieList(movieID: String) async throws -> SimilarMovieDTO {
        let result = await provider.request(.similarMovies(movieID))
        
        return try decapsulateResponse(result: result, type: SimilarMovieDTO.self)
    }
    
    func fetchRecommendMovieList(movieID: String) async throws -> RecommendationMovieDTO {
        let result = await provider.request(.recommendMovies(movieID))
        
        return try decapsulateResponse(result: result, type: RecommendationMovieDTO.self)
    }
    
    func fetchMovieVideoList(movieID: String) async throws -> MovieVideoDTO {
        let result = await provider.request(.videos(movieID))
        
        return try decapsulateResponse(result: result, type: MovieVideoDTO.self)
    }
    
    func fetchMovieImageList(movieID: String) async throws -> MovieGalleryDTO {
        let result = await provider.request(.images(movieID))
        
        return try decapsulateResponse(result: result, type: MovieGalleryDTO.self)
    }
    
    func fetchMovieCredits(movieID: String) async throws -> CreditDTO {
        let result = await provider.request(.credits(movieID))
        
        return try decapsulateResponse(result: result, type: CreditDTO.self)
    }
    
    private func decapsulateResponse<T: Decodable>(result: Result<Response, MoyaError>, type: T.Type) throws -> T {
        switch result {
        case .success(let response):
            return try response.map(type)
        case .failure(let error):
            throw error
        }
    }
}
