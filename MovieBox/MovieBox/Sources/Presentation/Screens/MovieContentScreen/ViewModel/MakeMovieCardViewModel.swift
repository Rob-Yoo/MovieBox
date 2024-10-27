//
//  MakeMovieCardViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import Foundation
import Combine

final class MakeMovieCardViewModel: ViewModel {
    var input: Input
    @Published var output: Output
    private var cancellables = Set<AnyCancellable>()
    private var initialRate: Int
    private var initialComment: String

    @Injected private var movieContentUseCase: MovieContentUseCase
    
    init(movieCard: MovieCard) {
        self.input = Input(comment: movieCard.comment)
        self.output = Output(movieCard: movieCard, isEditing: !movieCard.comment.isEmpty)
        self.initialRate = movieCard.rate
        self.initialComment = movieCard.comment
        transform()
    }
    
    func transform() {
        input.rate
            .sink { [weak self] rate in
                guard let self else { return }
                
                if (output.isEditing) {
                    output.isValidate = rate != initialRate
                }
                
                output.movieCard.rate = rate
            }
            .store(in: &cancellables)
        
        input.commentSubject
            .sink { [weak self] comment in
                guard let self else { return }

                
                if(output.isEditing) {
                    output.isValidate = (comment != initialComment && !comment.isEmpty)
                } else {
                    output.isValidate = !comment.isEmpty
                }
                
                output.movieCard.comment = comment
            }
            .store(in: &cancellables)
        
        input.saveMovieCard
            .sink { [weak self] _ in
                guard let self else { return }
                
                let entity = MovieContent.MovieCard(
                    movieID: output.movieCard.movieID,
                    poster: output.movieCard.poster,
                    title: output.movieCard.title,
                    rate: output.movieCard.rate,
                    comment: output.movieCard.comment,
                    createdAt: output.movieCard.creadedAt
                )
                
                if output.isEditing {
                    movieContentUseCase.updateMovieCard(entity)
                } else {
                    movieContentUseCase.saveMovieCard(entity)
                }
            }
            .store(in: &cancellables)
    }
    
    
}

extension MakeMovieCardViewModel {
    struct Input {
        let movieCard = PassthroughSubject<MovieCard, Never>()
        let saveMovieCard = PassthroughSubject<Void, Never>()
        let rate = PassthroughSubject<Int, Never>()
        fileprivate var commentSubject = PassthroughSubject<String, Never>()
        var comment: String {
            didSet {
                commentSubject.send(comment)
            }
        }
    }
    
    struct Output {
        var movieCard: MovieCard
        var isEditing: Bool
        var isValidate: Bool = false
    }
}
