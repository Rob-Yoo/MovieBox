//
//  MovieListViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Foundation
import Combine

final class MovieListViewModel: ViewModel {
    var input = Input()
    @Published var output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    private var movieListUseCase: MovieListUseCase
    
    init(movieListUseCase: MovieListUseCase) {
        self.movieListUseCase = movieListUseCase
        transform()
    }
    
    func transform() {
        input.loadWeeklyTrendMovieList
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.fetchWeeklyTrendMovieList()
                }
            }
            .store(in: &cancellables)
        
        input.showSearchView
            .sink { [weak self] bool in
                guard let self else { return }
                
                output.showSearchView = bool
                output.searchResults = []
                input.searchTextField = ""
            }
            .store(in: &cancellables)
        
        input.searchButtonTapped
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.fetchSearchResult(query: self.input.searchTextField, isPaging: false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchWeeklyTrendMovieList() async {
        let result = await movieListUseCase.fetchWeeklyTrendMovieList()
        
        switch result {
        case .success(let data):
            DispatchQueue.main.async { [weak self] in
                self?.output.weeklyTrendMovieList = data.movieList
            }
        case .failure(let error):
            print(#function, error.localizedDescription)
        }
    }
    
    private func fetchSearchResult(query: String, isPaging: Bool) async {
        let result = await movieListUseCase.searchMovie(query: query, isPaging: isPaging)
        
        switch result {
        case .success(let data):
            DispatchQueue.main.async { [weak self] in
                self?.output.searchResults = data.results
            }
        case .failure(let error):
            print(#function, error.localizedDescription)
        }
    }
}

extension MovieListViewModel {
    struct Input {
        var searchTextField = ""
        var searchButtonTapped = PassthroughSubject<Void, Never>()
        var showSearchView = PassthroughSubject<Bool, Never>()
        var loadWeeklyTrendMovieList = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var searchResults = [MoviePoster]()
        var showSearchView = false
        var number = 1
        var weeklyTrendMovieList = [WeeklyTrendMovieGallery.WeeklyTrendMovie]()
    }
}
