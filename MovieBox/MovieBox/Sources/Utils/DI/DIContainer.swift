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
        
        container.register(MovieListDataSource.self) { _ in
            return DefaultMovieListDataSource()
        }

        container.register(MovieListRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieListDataSource.self)!
            return DefaultMovieListRepository(dataSource: dataSource)
        }
        
        container.register(MovieListUseCase.self) { resolver in
            let repository = resolver.resolve(MovieListRepository.self)!
            return DefaultMovieListUseCase(movieListRepository: repository)
        }

        container.register(MovieListViewModel.self) { resolver in
            let useCase = resolver.resolve(MovieListUseCase.self)!
            return MovieListViewModel(movieListUseCase: useCase)
        }
        return container
    }
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency
    
    init() {
        self.wrappedValue = DIContainer.shared.container.resolve(Dependency.self)!
    }
}
