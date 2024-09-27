//
//  MovieBoxDataSource.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/26/24.
//

import RealmSwift
import Foundation

protocol MovieBoxDataSource {
    func createMovieCard(_ movieCard: MovieContent.MovieCard)
    func fetchMovieCardList() -> [(MovieCardDTO, Data?)]
    func updateMovieCard(_ movieCard: MovieContent.MovieCard)
    func deleteMovieCard(movieID: Int)
}

final class DefaultMovieBoxDataSource: MovieBoxDataSource {
    
    private let realm = try! Realm()
    private var list: Results<MovieCardDTO>
    
    init() {
        self.list = realm.objects(MovieCardDTO.self)
        print(realm.configuration.fileURL ?? "")
    }
    
    func createMovieCard(_ movieCard: MovieContent.MovieCard) {
        saveImageToDocument(imageData: movieCard.poster, movieID: movieCard.movieID)
        makeMovieCard(movieCard)
    }
    
    func fetchMovieCardList() -> [(MovieCardDTO, Data?)] {
        return list.map { ($0, loadImageData(movieID: $0.id)) }
    }
    
    func updateMovieCard(_ movieCard: MovieContent.MovieCard) {
        makeMovieCard(movieCard)
    }
    
    func deleteMovieCard(movieID: Int) {
        removeImageFromDocument(movieID: movieID)
        deleteMovieCard(movieID)
    }
    
}

extension DefaultMovieBoxDataSource {
    private func makeMovieCard(_ movie: MovieContent.MovieCard) {
        do {
            
            let card = MovieCardDTO(
                id: movie.movieID,
                rate: movie.rate,
                title: movie.title,
                createdAt: movie.createdAt,
                comment: movie.comment
            )
            
            try realm.write {
                realm.add(card, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    private func deleteMovieCard(_ movieID: Int) {
        do {
            try realm.write {
                let card = realm.object(ofType: MovieCardDTO.self, forPrimaryKey: movieID)!
                realm.delete(card)
            }
        } catch {
            print(error)
        }
    }
    
    private func saveImageToDocument(imageData: Data?, movieID: Int) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(movieID).jpg")
        
        do {
            try imageData?.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
    }
    
    private func removeImageFromDocument(movieID: Int) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent("\(movieID).jpg")
        let filePath: String
        
        if #available(iOS 16.0, *) {
            filePath = fileURL.path()
        } else {
            filePath = fileURL.path
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                print("file remove error", error)
            }
            
        } else {
            print("file no exist")
        }
        
    }

    private func loadImageData(movieID: Int) -> Data? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(movieID).jpg")
        let filePath: String
        
        if #available(iOS 16.0, *) {
            filePath = fileURL.path()
        } else {
            filePath = fileURL.path
        }
        
        guard FileManager.default.fileExists(atPath: filePath) else { return nil }
        
        do {
            let imageData = try Data(contentsOf: URL(filePath: filePath))
            return imageData
        } catch {
            print("FilePath로 Image Data 변환하기 실패")
            return nil
        }
    }
}
