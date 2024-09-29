//
//  MovieBoxViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/28/24.
//

import Foundation
import Combine

final class MovieBoxViewModel: ViewModel {
    var input = Input()
    @Published var output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var movieBoxRepository: MovieBoxRepository
    
    init() {
        transform()
    }
    
    func transform() {
        input.loadMovieCardList
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                let movieCardList = movieBoxRepository.fetchMovieCardList()
                output.movieCardList = movieCardList.enumerated().map {
                    MovieBoxCard(
                        movieID: $1.movieID,
                        index: $0,
                        poster: $1.poster,
                        title: $1.title,
                        rate: $1.rate,
                        comment: $1.comment,
                        createdAt: $1.createdAt
                    )
                }
            }
            .store(in: &cancellables)
    }
}

extension MovieBoxViewModel {
    struct Input {
        let loadMovieCardList = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var movieCardList = [MovieBoxCard]()
    }
}

struct MovieBoxCard {
    let movieID: Int
    let index: Int
    let poster: Data?
    let title: String
    let rate: Int
    let comment: String
    let createdAt: Date
}
