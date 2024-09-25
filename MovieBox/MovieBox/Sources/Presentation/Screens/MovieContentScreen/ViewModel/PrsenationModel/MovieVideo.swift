//
//  MovieVideo.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/26/24.
//

import Foundation

struct MovieVideo: Hashable {
    let title: String
    let videoPath: String

    static func makeModel(_ entity: MovieContent.MovieVideoGallery.MovieVideo) -> Self {
        var title = entity.name
        
        if let _ = title.firstIndex(of: "["), let rightBracketIndex = title.firstIndex(of: "]") {

            let result = title.suffix(from: title.index(after: rightBracketIndex))
            title = result.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return MovieVideo(title: title, videoPath: entity.videoPath)
    }
}
