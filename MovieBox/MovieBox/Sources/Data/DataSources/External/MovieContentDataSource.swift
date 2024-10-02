//
//  MovieContentDataSource.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Moya

protocol MovieContentDataSource {
    func fetchMovieInfo(movieID: Int) async throws -> MovieInfoDTO
    func fetchSimilarMovieList(movieID: Int) async throws -> SimilarMovieDTO
    func fetchRecommendMovieList(movieID: Int) async throws -> RecommendationMovieDTO
    func fetchMovieVideoList(movieID: Int) async throws -> MovieVideoDTO
    func fetchMovieImageList(movieID: Int) async throws -> MovieGalleryDTO
    func fetchMovieCredits(movieID: Int) async throws -> CreditDTO
}

final class DefaultMovieContentDataSource: MovieContentDataSource {
    private let provider = MoyaProvider<TMDBRequest>()
    
    func fetchMovieInfo(movieID: Int) async throws -> MovieInfoDTO {
        let result = await provider.request(.movieContent(movieID))
        
        return try decapsulateResponse(result: result, type: MovieInfoDTO.self)
    }
    
    func fetchSimilarMovieList(movieID: Int) async throws -> SimilarMovieDTO {
        let result = await provider.request(.similarMovies(movieID))
        
        return try decapsulateResponse(result: result, type: SimilarMovieDTO.self)
    }
    
    func fetchRecommendMovieList(movieID: Int) async throws -> RecommendationMovieDTO {
        let result = await provider.request(.recommendMovies(movieID))
        
        return try decapsulateResponse(result: result, type: RecommendationMovieDTO.self)
    }
    
    func fetchMovieVideoList(movieID: Int) async throws -> MovieVideoDTO {
        let result = await provider.request(.videos(movieID))
        
        return try decapsulateResponse(result: result, type: MovieVideoDTO.self)
    }
    
    func fetchMovieImageList(movieID: Int) async throws -> MovieGalleryDTO {
        let result = await provider.request(.images(movieID))
        
        return try decapsulateResponse(result: result, type: MovieGalleryDTO.self)
    }
    
    func fetchMovieCredits(movieID: Int) async throws -> CreditDTO {
        let result = await provider.request(.credits(movieID))
        
        return try decapsulateResponse(result: result, type: CreditDTO.self)
    }
    
    private func decapsulateResponse<T: Decodable>(result: Result<Response, MoyaError>, type: T.Type) throws -> T {
        switch result {
        case .success(let response):
            return try response.map(type)
        case .failure(let error):
            print(error.localizedDescription)
            throw error
        }
    }
}
