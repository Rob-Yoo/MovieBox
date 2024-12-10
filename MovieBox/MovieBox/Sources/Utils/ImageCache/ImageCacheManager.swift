//
//  ImageCache.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/4/24.
//

import Foundation
import Alamofire
import UIKit.UIImage

final class CacheableImage {
    let etag: String
    let imageData: Data
    
    init(etag: String, imageData: Data) {
        self.etag = etag
        self.imageData = imageData
    }
}

final class ImageCacheManager {
    
    enum CacheType {
        case memoryCache
        case diskCache
        case all
    }
    
    static let shared = ImageCacheManager()
    private let memoryCache: MemoryCache = {
        let mCache = MemoryCache()
        mCache.configureCachePolicy(with: 10 * 1024 * 1024)
        return mCache
    }()
    private let diskCache = DiskCache(400 * 1024 * 1024)
    private init() {}
    
    func getImage(_ imagePath: String, _ cacheType: CacheType) async -> Data? {
        
        guard !imagePath.isEmpty else { return nil }
        
        if (cacheType == .all || cacheType == .memoryCache),
           let image = memoryCache.read(with: imagePath) {
            print("메모리 캐시 히트")
            return image.imageData
        }
        
        if (cacheType == .all || cacheType == .diskCache),
            let image = await diskCache.get(imagePath) {
            print("디스크 캐시 히트")

            if let etag = UserDefaults.standard.string(forKey: imagePath),
               let imageData = await synchronizeWithServer(imagePath: imagePath, etag: etag, cacheType)
            {
                return imageData
            }
            
            return image
        }
        
        return await synchronizeWithServer(imagePath: imagePath, etag: nil, cacheType)
    }
    
    func loadDiskCacheState() {
        diskCache.loadState()
    }
}

extension ImageCacheManager {
    private func synchronizeWithServer(imagePath: String, etag: String? = nil, _ cacheType: CacheType) async -> Data? {
        let imageUrl = API.tmdbImageRequestBaseUrl + imagePath
        var headers: HTTPHeaders = [:]
        
        if let etag {
            headers = ["If-None-Match": etag]
        }

        let res = await AF.request(imageUrl, headers: headers).validate().serializingData().response
        
        switch res.result {
        case .success(let imageData):
            
            guard let etag = res.response?.allHeaderFields["Etag"] as? String else {
                print("Header 필드에 ETag 값이 없음")
                return nil
            }
            
            UserDefaults.standard.setValue(etag, forKey: imagePath)
            switch cacheType {
            case .all:
                memoryCache.save(imagePath, data: CacheableImage(etag: etag, imageData: imageData))
                diskCache.put(imagePath, data: imageData)
            case .memoryCache:
                memoryCache.save(imagePath, data: CacheableImage(etag: etag, imageData: imageData))
            case .diskCache:
                diskCache.put(imagePath, data: imageData)
            }
            
            return imageData
        case .failure(let error):
            if let statusCode = error.responseCode {
                if statusCode == 304 {
                    print("Not Modified")
                } else {
                    print(error.localizedDescription)
                }
            }
            return nil
        }
    }
}
