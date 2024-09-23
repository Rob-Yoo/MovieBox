//
//  WeeklyTrendMovieGallery.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct WeeklyTrendMovieGallery {
    
    struct WeeklyTrendMovie {
        let id: Int
        let posterPath: String
        let name: String
        let releaseYear: String
    }
    
    let movieList: [WeeklyTrendMovie]
}
