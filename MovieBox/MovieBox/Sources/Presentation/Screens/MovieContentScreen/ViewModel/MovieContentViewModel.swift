//
//  MovieContentViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import Foundation
import Combine

final class MovieContentViewModel: ViewModel {

    private let movieID: Int
    var input = Input()
    @Published var output = Output()
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var movieContentUseCase: MovieContentUseCase
    
    init(movieID: Int) {
        self.movieID = movieID
        transform()
    }
    
    func transform() {
        Task { await fetchMovieContent(movieID: movieID) }
    }
}

extension MovieContentViewModel {
    private func fetchMovieContent(movieID: Int) async {
        let content = await movieContentUseCase.fetchMovieContent(movieID: movieID)

        let movieCard = (content.movieCard == nil) ? await MovieCard.makeMovieCard(movieInfo: content.info) : MovieCard.makeMovieCard(content.movieCard!)

        DispatchQueue.main.async { [weak self] in
            self?.output.showActivityIndicator = false
            self?.output.movieInfo = MovieInfo.makeModel(content.info)
            self?.output.movieCredit = content.credit
            self?.output.movieImageGallery = content.imageGallery
            self?.output.movieVideoGallery = content.videoGallery.videoList.map { MovieVideo.makeModel($0) }
            self?.output.similarMovies = content.similarMovieGallery
            self?.output.recommendMovies = content.recmdMovieGallery
            self?.output.movieCard = movieCard
        }
    }
}

extension MovieContentViewModel {
    
    struct Input {}
    
    struct Output {
        var movieInfo = MovieInfo()
        var movieCredit = MovieContent.MovieCredit(castList: [])
        var movieImageGallery = MovieContent.MovieImageGallery(backdropPathList: [])
        var movieVideoGallery = [MovieVideo]()
        var similarMovies = MovieContent.SimilarMovieGallery(posterList: [])
        var recommendMovies = MovieContent.RecommendationMovieGallery(posterList: [])
        var movieCard = MovieCard(movieID: 0, poster: nil, title: "", rate: 0, comment: "", creadedAt: .now)
        var showActivityIndicator = true
    }
}
