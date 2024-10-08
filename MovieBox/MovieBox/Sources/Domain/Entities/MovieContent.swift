//
//  MovieDetail.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct MovieContent {
    let info: MovieInfo
    let credit: MovieCredit
    let imageGallery: MovieImageGallery
    let videoGallery: MovieVideoGallery
    let similarMovieGallery: SimilarMovieGallery
    let recmdMovieGallery: RecommendationMovieGallery
    var movieCard: MovieCard?
}

extension MovieContent {
    // 영화 세부 정보
    struct MovieInfo {
        let id: Int
        let posterPath: String
        let backdropPath: String
        let genres: [String]
        let country: [String]
        let title: String
        let runtime: Int
        let overview: String
        let releaseYear: String
    }

    // 캐스팅
    struct MovieCredit {
        
        struct Cast: Hashable {
            let name: String
            let profilePath: String
        }
        
        let castList: [Cast]
    }

    // 영화 사진 갤러리
    struct MovieImageGallery {
        let backdropPathList: [String]
    }

    // 영화 동영상 갤러리
    struct MovieVideoGallery {
        
        struct MovieVideo: Hashable {
            let name: String
            let videoPath: String
        }
        
        let videoList: [MovieVideo]
    }

    // 비슷한 영화 갤러리
    struct SimilarMovieGallery {
        let posterList: [MoviePoster]
    }

    // 추천 영화 갤러리
    struct RecommendationMovieGallery {
        let posterList: [MoviePoster]
    }
    
    struct MovieCard {
        let movieID: Int
        let poster: Data?
        let title: String
        let rate: Int
        let comment: String
        let createdAt: Date
    }
}
