//
//  ImageCache.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/4/24.
//

import Foundation
import Alamofire

final class CacheableImage {
    let imageData: Data
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let memoryCache: MemoryCache = {
        let mCache = MemoryCache()
        mCache.configureCachePolicy(with: 10 * 1024 * 1024)
        return mCache
    }()
    private let diskCache = DiskCache(100 * 1024 * 1024)
    private init() {}
    
    func getImage(_ url: String) async -> Data? {
        
        guard !url.isEmpty else { return nil }
        
        if let image = memoryCache.read(with: url) {
            print("메모리 캐시 히트")
            return image.imageData
        }
        
        if let image = await diskCache.get(url) {
            print("디스크 캐시 히트")
            return image
        }
        
        let result = await AF.request(url).serializingData().result
        
        switch result {
        case .success(let imageData):
            let cachableImage = CacheableImage(imageData: imageData)
            memoryCache.save(url, data: cachableImage)
            await diskCache.put(url, data: cachableImage.imageData)
            return imageData
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveDiskCacheState() {
        diskCache.saveState()
    }
    
    func loadDiskCacheState() {
        diskCache.loadState()
    }
}
