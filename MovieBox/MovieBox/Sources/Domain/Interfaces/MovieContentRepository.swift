//
//  MovieContentRepository.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation

protocol MovieContentRepository {
    func fetchMovieContent(movieID: Int) async -> MovieContent
}
