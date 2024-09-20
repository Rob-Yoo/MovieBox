//
//  BoxOfficeDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/19/24.
//

import Foundation

struct BoxOfficeDTO: Decodable {
    let boxOfficeResult: DailyBoxOfficeListDTO
}

struct DailyBoxOfficeListDTO: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeDTO]
}

struct DailyBoxOfficeDTO: Decodable {
    let rank: String // 순위
    let rankInten: String // 순위증감분
    let rankOldAndNew: String // 신규진입여부
    let movieNm: String //영화명
    let audiAcc: String // 총 관객수
}

extension BoxOfficeDTO {
    func toDomain() -> DailyBoxOfficeGallery {
        let movieList = self.boxOfficeResult.dailyBoxOfficeList.map { $0.toDomain() }
        
        return DailyBoxOfficeGallery(movieList: movieList)
    }
}

extension DailyBoxOfficeDTO {
    func toDomain() -> DailyBoxOfficeGallery.DailyBoxOffice {
        let isNew = (self.rankOldAndNew == "NEW")

        return DailyBoxOfficeGallery.DailyBoxOffice(
            movieName: self.movieNm,
            rank: Int(self.rank)!,
            rankInten: Int(self.rankInten)!,
            isNew: isNew,
            numberOfAudience: Int(self.audiAcc)!
        )
    }
}
