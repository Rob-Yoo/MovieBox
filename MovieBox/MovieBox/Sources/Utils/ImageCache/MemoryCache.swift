//
//  ImageCache.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/4/24.
//

import Foundation

final class MemoryCache {
    private var cache = NSCache<NSString, CacheableImage>()
    
    func configureCachePolicy(with maximumMemoryBytes: Int) {
        cache.totalCostLimit = maximumMemoryBytes
    }
    
    func save(_ key: String, data: CacheableImage) {
        let key = NSString(string: key)
        cache.setObject(data, forKey: key, cost: data.imageData.count)
    }
    
    func read(with key: String) -> CacheableImage? {
        let key = NSString(string: key)
        return cache.object(forKey: key)
    }
}
