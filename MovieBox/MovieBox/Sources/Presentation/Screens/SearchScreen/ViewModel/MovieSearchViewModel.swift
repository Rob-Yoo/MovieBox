//
//  MovieSearchViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import Foundation
import Combine

final class MovieSearchViewModel: ViewModel {
    let input = Input()
    @Published var output = Output()
    
    private var cancellables = Set<AnyCancellable>()
    @Injected private var movieListUseCase: MovieListUseCase
    
    func transform() {
        input.loadWeeklyTrendMovieList
            .sink { [weak self] _ in
                guard let self else { return }
                
                Task {
                    await self.fetchWeeklyTrendMovieList()
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetchWeeklyTrendMovieList() async {
        let result = await movieListUseCase.fetchWeeklyTrendMovieList()
        
        switch result {
        case .success(let data):
            output.weeklyTrendMovieList = data.posterList
        case .failure(let error):
            print(#function, error.localizedDescription)
        }
    }
}

extension MovieSearchViewModel {
    struct Input {
        var searchTextField = ""
        var loadWeeklyTrendMovieList = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var searchResults = [MoviePoster]()
        var weeklyTrendMovieList = [MoviePoster]()
    }
}
