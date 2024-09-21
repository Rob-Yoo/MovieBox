//
//  DailyBoxOffice.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/19/24.
//

import Foundation

struct DailyBoxOfficeGallery {
    
    struct DailyBoxOffice {
        let movieName: String
        let rank: Int
        let rankInten: Int
        let isNew: Bool
        let numberOfAudience: Int
        var poster: MoviePoster
    }
    
    var movieList: [DailyBoxOffice]
}

