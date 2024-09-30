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
    
    @Injected private var movieListUseCase: MovieListUseCase
    
    init() {
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
        
        input.showActivityIndicator
            .sink { [weak self] value in
                guard let self else { return }
                
                output.showActivityIndicator = value
            }
            .store(in: &cancellables)
        
        input.paginationTrigger
            .sink { [weak self] _ in
                guard let self else { return }

                Task { await self.fetchSearchResult(query: self.input.searchTextField, isPaging: true) }
                output.showActivityIndicator = true
            }
            .store(in: &cancellables)
        
        input.scrollToTop
            .sink { [weak self] value in
                guard let self else { return }
                
                output.scrollToTop = value
            }
            .store(in: &cancellables)
    }
    
    private func fetchWeeklyTrendMovieList() async {
        let result = await movieListUseCase.fetchWeeklyTrendMovieList()
        
        switch result {
        case .success(let data):
            DispatchQueue.main.async { [weak self] in
                self?.output.weeklyTrendMovieList = data.movieList
                self?.input.showActivityIndicator.send(false)
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
                
                if (isPaging) {
                    self?.output.searchResults += data.results
                } else {
                    self?.output.searchResults = data.results
                    if !(data.results.isEmpty) {
                        self?.output.scrollToTop = true                        
                    }
                }

                self?.input.showActivityIndicator.send(false)
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
        var showActivityIndicator = PassthroughSubject<Bool, Never>()
        var paginationTrigger = PassthroughSubject<Void, Never>()
        var scrollToTop = PassthroughSubject<Bool, Never>()
    }
    
    struct Output {
        var searchResults = [MoviePoster]()
        var showSearchView = false
        var number = 1
        var weeklyTrendMovieList = [WeeklyTrendMovieGallery.WeeklyTrendMovie]()
        var showActivityIndicator = true
        var scrollToTop = false
    }
}
