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
    static let shared = ImageCacheManager()
    private let memoryCache: MemoryCache = {
        let mCache = MemoryCache()
        mCache.configureCachePolicy(with: 10 * 1024 * 1024)
        return mCache
    }()
    private let diskCache = DiskCache(100 * 1024 * 1024)
    private init() {}
    
    func getImage(_ imagePath: String) async -> Data? {
        
        guard !imagePath.isEmpty else { return nil }
        
        if let image = memoryCache.read(with: imagePath) {
            print("메모리 캐시 히트")
            if let imageData = await synchronizeWithServer(imagePath: imagePath, etag: image.etag) {
                print("서버 동기화")
                return imageData
            }
            
            return image.imageData
        }
        
        if let image = await diskCache.get(imagePath) {
            print("디스크 캐시 히트")

            if let etag = UserDefaults.standard.string(forKey: imagePath),
               let imageData = await synchronizeWithServer(imagePath: imagePath, etag: etag)
            {
                print("서버 동기화")
                return imageData
            }
            
            return image
        }
        
        return await synchronizeWithServer(imagePath: imagePath)
    }
    
    func saveDiskCacheState() {
        diskCache.saveState()
    }
    
    func loadDiskCacheState() {
        diskCache.loadState()
    }
}

extension ImageCacheManager {
    private func synchronizeWithServer(imagePath: String, etag: String? = nil) async -> Data? {
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
            memoryCache.save(imagePath, data: CacheableImage(etag: etag, imageData: imageData))
            await diskCache.put(imagePath, data: imageData)
            
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


/*import UIKit

// 메모리 캐시를 위한 NSCache
class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    let memoryCache = NSCache<NSString, UIImage>()
    
    // 디스크 캐시 경로 설정
    private let cacheDirectory: URL = {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheDir = cachesDirectory.appendingPathComponent("ImageCache")
        if !FileManager.default.fileExists(atPath: cacheDir.path) {
            try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheDir
    }()
    
    // 이미지를 메모리에 저장
    func storeImageInMemory(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
    
    // 이미지를 디스크에 저장
    func storeImageInDisk(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
    
    // 메모리 캐시에서 이미지 가져오기
    func getImageFromMemory(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
    
    // 디스크 캐시에서 이미지 가져오기
    func getImageFromDisk(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }
}

// 이미지 로더
class ImageLoader {
    static let shared = ImageLoader()

    // 이미지를 로드하고 캐싱하는 메서드
    func loadImage(from url: URL, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString.md5 // URL을 키로 사용 (md5로 변환해서 키로 사용)
        
        // 1. 메모리 캐시 확인
        if let cachedImage = ImageCache.shared.getImageFromMemory(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // 2. 디스크 캐시 확인
        if let cachedImage = ImageCache.shared.getImageFromDisk(forKey: cacheKey) {
            // 메모리 캐시에도 저장
            ImageCache.shared.storeImageInMemory(cachedImage, forKey: cacheKey)
            completion(cachedImage)
            return
        }
        
        // 3. 캐시에 없으면 URL에서 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            
            // 4. 이미지 리사이징
            let resizedImage = self.resizeImage(image: image, targetSize: size)
            
            // 5. 메모리 & 디스크 캐시 저장
            ImageCache.shared.storeImageInMemory(resizedImage, forKey: cacheKey)
            ImageCache.shared.storeImageInDisk(resizedImage, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(resizedImage)
            }
        }.resume()
    }
    
    // 이미지 리사이징
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Resize image by preserving aspect ratio
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

// MD5 해시 확장 (URL을 캐시 키로 사용하기 위해서)
extension String {
    var md5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
*/
