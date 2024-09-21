//
//  DailyBoxOfficeGalleryMapper.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation

enum DailyBoxOfficeGalleryMapper {
    static func toDomain(boxOffice: BoxOfficeDTO, posterList: [MoviePosterDTO]) -> DailyBoxOfficeGallery {
        var movieList = [DailyBoxOfficeGallery.DailyBoxOffice]()
        let dailyBoxOfficeList = boxOffice.boxOfficeResult.dailyBoxOfficeList
        
        for (dailyBoxOffice, poster) in zip(dailyBoxOfficeList, posterList) {
            let isNew = (dailyBoxOffice.rankOldAndNew == "NEW")
            let movie = DailyBoxOfficeGallery.DailyBoxOffice(
                movieName: dailyBoxOffice.movieNm,
                rank: Int(dailyBoxOffice.rank)!,
                rankInten: Int(dailyBoxOffice.rankInten)!,
                isNew: isNew,
                numberOfAudience: Int(dailyBoxOffice.audiAcc)!,
                poster: poster.toDomain()
            )
            
            movieList.append(movie)
        }
        
        return DailyBoxOfficeGallery(movieList: movieList)
    }
}
