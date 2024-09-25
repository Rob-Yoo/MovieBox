//
//  DIContatiner.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/23/24.
//

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    var container: Container {
        get {
            if _container == nil {
                _container = buildContainer()
            }
            
            return _container!
        }
        
        set {
            _container = newValue
        }
    }
    private var _container: Container?
    
    func buildContainer() -> Container {
        let container = Container()
        
        buildDataSources(container)
        buildRepositories(container)
        buildUseCases(container)
        buildViewModels(container)
        
        return container
    }
    
    private func buildDataSources(_ container: Container) {
        container.register(MovieListDataSource.self) { _ in
            return DefaultMovieListDataSource()
        }
        
        container.register(MovieContentDataSource.self) { _ in
            return DefaultMovieContentDataSource()
        }
    }
    
    private func buildRepositories(_ container: Container) {
        container.register(MovieListRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieListDataSource.self)!
            return DefaultMovieListRepository(dataSource: dataSource)
        }
        
        container.register(MovieContentRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieContentDataSource.self)!
            return DefaultMovieContentRepository(datasource: dataSource)
        }
    }
    
    private func buildUseCases(_ container: Container) {
        container.register(MovieListUseCase.self) { resolver in
            let repository = resolver.resolve(MovieListRepository.self)!
            return DefaultMovieListUseCase(movieListRepository: repository)
        }
        
        container.register(MovieContentUseCase.self) { resolver in
            let repository = resolver.resolve(MovieContentRepository.self)!
            return DefaultMovieContentUseCase(movieContentRepository: repository)
        }
    }
    
    private func buildViewModels(_ container: Container) {
        container.register(MovieListViewModel.self) { resolver in
            let useCase = resolver.resolve(MovieListUseCase.self)!
            return MovieListViewModel(movieListUseCase: useCase)
        }
        
        container.register(MovieContentViewModel.self) { resolver in
            let useCase = resolver.resolve(MovieContentUseCase.self)!
            return MovieContentViewModel(movieContentUseCase: useCase)
        }
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency
    
    init() {
        self.wrappedValue = DIContainer.shared.container.resolve(Dependency.self)!
    }
}
