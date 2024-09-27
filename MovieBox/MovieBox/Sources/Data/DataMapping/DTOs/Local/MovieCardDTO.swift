//
//  MovieCardDTO.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/26/24.
//

import Foundation
import RealmSwift

final class MovieCardDTO: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted(indexed: true) var rate: Int
    @Persisted var title: String
    @Persisted var createdAt: Date
    @Persisted var comment: String
    
    convenience init(
        id: Int,
        rate: Int,
        title: String,
        createdAt: Date,
        comment: String)
    {
        self.init()
        self.id = id
        self.rate = rate
        self.title = title
        self.createdAt = createdAt
        self.comment = comment
    }
}
