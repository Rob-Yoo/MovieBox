//
//  MovieVideoDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MovieVideoDTO: Decodable {
    let results: [VideoDTO]
}

struct VideoDTO: Decodable {
    let name: String
    let key: String
}

extension MovieVideoDTO {
    func toDomain() -> MovieVideoGallery {
        return MovieVideoGallery(videoList: self.results.map { $0.toDomain() })
    }
}

extension VideoDTO {
    func toDomain() -> MovieVideoGallery.MovieVideo {
        let videoPath = "https://www.youtube.com/watch?v=\(self.key)"
        
        return MovieVideoGallery.MovieVideo(name: self.name, videoPath: videoPath)
    }
}
