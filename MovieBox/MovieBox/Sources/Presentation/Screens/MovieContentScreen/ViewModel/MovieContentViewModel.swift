//
//  MovieContentViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import Foundation
import Combine

final class MovieContentViewModel: ViewModel {

    var input = Input()
    @Published var output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    private let movieContentUseCase: MovieContentUseCase
    
    init(movieContentUseCase: MovieContentUseCase) {
        self.movieContentUseCase = movieContentUseCase
        transform()
    }
    
    func transform() {
        input.loadMovieContent
            .sink { [weak self] movieID in
                guard let self else { return }

                Task { await self.fetchMovieContent(movieID: movieID) }
            }
            .store(in: &cancellables)
    }
}

extension MovieContentViewModel {
    private func fetchMovieContent(movieID: Int) async {
        let result = await movieContentUseCase.fetchMovieContent(movieID: movieID)

        switch result {
        case .success(let content):
            DispatchQueue.main.async { [weak self] in
                self?.output.movieInfo = MovieInfo.makeModel(content.info)
                self?.output.movieCredit = content.credit
                self?.output.movieImageGallery = content.imageGallery
                self?.output.movieVideoGallery = content.videoGallery.videoList.map { MovieVideo.makeModel($0) }
                self?.output.similarMovies = content.similarMovieGallery
                self?.output.recommendMovies = content.recmdMovieGallery
            }
        case .failure(let error):
            print(#function, error.localizedDescription)
        }
    }
}

extension MovieContentViewModel {
    
    struct Input {
        let loadMovieContent = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var movieInfo = MovieInfo()
        var movieCredit = MovieContent.MovieCredit(castList: [])
        var movieImageGallery = MovieContent.MovieImageGallery(backdropPathList: [])
        var movieVideoGallery = [MovieVideo]()
        var similarMovies = MovieContent.SimilarMovieGallery(posterList: [])
        var recommendMovies = MovieContent.RecommendationMovieGallery(posterList: [])
    }
}
