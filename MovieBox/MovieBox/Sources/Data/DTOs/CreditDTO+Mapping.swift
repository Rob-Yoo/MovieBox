//
//  CreditDTO+Mapping.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

struct CreditDTO: Decodable {
    let cast: [CastDTO]
}

struct CastDTO: Decodable {
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case profilePath = "profile_path"
    }
}

extension CreditDTO {
    func toDomain() -> MovieCredit {
        let castList = self.cast.map { $0.toDomain() }
        
        return MovieCredit(castList: castList)
    }
}

extension CastDTO {
    func toDomain() -> MovieCredit.Cast {
        let profilePath = API.tmdbImageRequestBaseUrl + (self.profilePath ?? "")
        
        return MovieCredit.Cast(name: self.name, profilePath: profilePath)
    }
}
