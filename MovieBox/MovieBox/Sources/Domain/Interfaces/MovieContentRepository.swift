//
//  MovieContentRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation

protocol MovieContentRepository {
    func fetchMovieContent(movieID: String) async -> Result<MovieContent, Error>
//    func fetchMovieInfo(movieID: String) async -> Result<MovieContent.MovieInfo, Error>
//    func fetchSimilarMovieList(movieID: String) async -> Result<MovieContent.SimilarMovieGallery, Error>
//    func fetchRecommendMovieList(movieID: String) async -> Result<MovieContent.RecommendationMovieGallery, Error>
//    func fetchMovieVideoList(movieID: String) async -> Result<MovieContent.MovieVideoGallery, Error>
//    func fetchMovieImageList(movieID: String) async -> Result<MovieContent.MovieImageGallery, Error>
//    func fetchMovieCredits(movieID: String) async -> Result<MovieContent.MovieCredit, Error>
}
