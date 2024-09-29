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
        
        return container
    }
    
    private func buildDataSources(_ container: Container) {
        container.register(MovieListDataSource.self) { _ in
            return DefaultMovieListDataSource()
        }
        .inObjectScope(.container)
        
        container.register(MovieContentDataSource.self) { _ in
            return DefaultMovieContentDataSource()
        }
        .inObjectScope(.container)
        
        container.register(MovieBoxDataSource.self) { _ in
            return DefaultMovieBoxDataSource()
        }
        .inObjectScope(.container)
    }
    
    private func buildRepositories(_ container: Container) {
        container.register(MovieListRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieListDataSource.self)!
            return DefaultMovieListRepository(dataSource: dataSource)
        }
        .inObjectScope(.container)
        
        container.register(MovieContentRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieContentDataSource.self)!
            return DefaultMovieContentRepository(datasource: dataSource)
        }
        .inObjectScope(.container)
        
        container.register(MovieBoxRepository.self) { resolver in
            let dataSource = resolver.resolve(MovieBoxDataSource.self)!
            return DefaultMovieBoxRepository(dataSource: dataSource)
        }
        .inObjectScope(.container)
    }
    
    private func buildUseCases(_ container: Container) {
        container.register(MovieListUseCase.self) { resolver in
            let repository = resolver.resolve(MovieListRepository.self)!
            return DefaultMovieListUseCase(movieListRepository: repository)
        }
        .inObjectScope(.container)
        
        container.register(MovieContentUseCase.self) { resolver in
            let movieContentRepository = resolver.resolve(MovieContentRepository.self)!
            let movieBoxRepository = resolver.resolve(MovieBoxRepository.self)!

            return DefaultMovieContentUseCase(
                movieContentRepository: movieContentRepository,
                movieBoxRepository: movieBoxRepository
            )
        }
        .inObjectScope(.container)
    }

}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency
    
    init() {
        self.wrappedValue = DIContainer.shared.container.resolve(Dependency.self)!
    }
}
