//
//  TMDBRequest.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation
import Moya

enum TMDBRequest {
    case weeklyTrendMovies
    case searchMovie(query: String, page: Int)
    case movieDetail(_ movieID: String)
    case similarMovies(_ movieID: String)
    case recommendMovies(_ movieID: String)
    case videos(_ movieID: String)
    case credits(_ movieID: String)
    case images(_ movieID: String)
}

extension TMDBRequest: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .weeklyTrendMovies:
            return "/trending/movie/week"
        case .searchMovie:
            return "/search/movie"
        case .movieDetail(let movieID):
            return "/movie/\(movieID)"
        case .similarMovies(let movieID):
            return "/movie/\(movieID)/similar"
        case .recommendMovies(let movieID):
            return "/movie/\(movieID)/recommendations"
        case .videos(let movieID):
            return "/movie/\(movieID)/videos"
        case .credits(let movieID):
            return "/movie/\(movieID)/credits"
        case .images(let movieID):
            return "/movie/\(movieID)/images"
        }
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        switch self {
        case .weeklyTrendMovies,
                .movieDetail,
                .similarMovies,
                .recommendMovies,
                .videos,
                .credits:
            let parameters = ["language": "ko-KR" ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)

        case .searchMovie(let query, let page):
            let parameters: [String: Any]  = [
                "query": query,
                "language": "ko-KR",
                "include_adult": true,
                "page": page
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)

        case .images:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Authorization": API.tmdbKey]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
