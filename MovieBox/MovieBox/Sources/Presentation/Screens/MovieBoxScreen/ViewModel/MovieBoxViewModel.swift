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
    private var removingList = Set<Int>()
    
    @Injected private var movieBoxRepository: MovieBoxRepository
    
    init() {
        transform()
    }
    
    func transform() {
        input.loadMovieCardList
            .sink { [weak self] _ in
                
                guard let self else { return }
                
                let movieCardList = movieBoxRepository.fetchMovieCardList()
                
                if (movieCardList.isEmpty && output.isRemovingMode == true) {
                    output.isRemovingMode = false
                }
                
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
                .reversed()
            }
            .store(in: &cancellables)
        
        input.addRemovingList
            .sink { [weak self] movieID in
                guard let self else { return }
                
                removingList.insert(movieID)
                output.removingListCount = removingList.count
            }
            .store(in: &cancellables)
        
        input.removeRemovingList
            .sink { [weak self] movieID in
                
                guard let self else { return }
                
                removingList.remove(movieID)
                output.removingListCount = removingList.count
            }
            .store(in: &cancellables)
        
        input.removeMovieCardsTrigger
            .sink { [weak self] _ in
                guard let self else { return }
                
                removingList.forEach { movieID in
                    self.movieBoxRepository.deleteMovieCard(movieID: movieID)
                }
                removingList.removeAll()
                input.loadMovieCardList.send(())
                output.removingListCount = removingList.count
            }
            .store(in: &cancellables)
        
        input.isRemovingMode
            .sink { [weak self] value in
                guard let self else { return }
                
                if (value == false) {
                    removingList.removeAll()
                    output.removingListCount = 0
                }
                output.isRemovingMode = value
            }
            .store(in: &cancellables)
    }
}

extension MovieBoxViewModel {
    struct Input {
        let loadMovieCardList = PassthroughSubject<Void, Never>()
        let isRemovingMode = PassthroughSubject<Bool, Never>()
        let addRemovingList = PassthroughSubject<Int, Never>()
        let removeRemovingList = PassthroughSubject<Int, Never>()
        let removeMovieCardsTrigger = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var movieCardList = [MovieBoxCard]()
        var removingListCount = 0
        var isRemovingMode = false
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
