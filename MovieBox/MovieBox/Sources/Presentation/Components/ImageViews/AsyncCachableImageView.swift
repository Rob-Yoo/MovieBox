//
//  AsyncCachableImageView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/4/24.
//

import SwiftUI
import UIKit.UIImage

struct AsyncCachableImageView: View {
    @StateObject private var viewModel: AsyncCachableImageViewModel
    private let size: CGSize
    private var urlString: String
    
    init(urlString: String, size: CGSize, cacheType: ImageCacheManager.CacheType = .all) {
        self.size = size
        self.urlString = urlString
        _viewModel = StateObject(wrappedValue: AsyncCachableImageViewModel(urlString: urlString, cacheType: cacheType))
    }
    
    var body: some View {
        Group {
            if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                let render = UIGraphicsImageRenderer(size: size)
                let resizedImage = render.image { _ in
                    uiImage.draw(in: CGRect(origin: .zero, size: size))
                }
                
                Image(uiImage: resizedImage)
                    .scaledToFit()
            } else {
                ImagePlaceholderView(width: size.width, height: size.height)
            }
        }
        .onChange(of: urlString) { newURL in
            viewModel.updateURL(newURL)
        }
    }
}


final class AsyncCachableImageViewModel: ObservableObject {
    @Published var imageData: Data?
    private var currentURL: String
    
    private let cacheType: ImageCacheManager.CacheType
    private let imageCacheManager = ImageCacheManager.shared
    
    init(urlString: String, cacheType: ImageCacheManager.CacheType) {
        self.currentURL = urlString
        self.cacheType = cacheType
        loadImage()
    }
    
    fileprivate func updateURL(_ newURL: String) {
        guard newURL != currentURL else { return }
        currentURL = newURL
        loadImage()
    }
    
    fileprivate func loadImage() {
        guard imageData == nil else { return }
        
        Task {
            if let data = await imageCacheManager.getImage(currentURL, cacheType) {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }
    }
}

#Preview {
    AsyncCachableImageView(urlString: "https://image.tmdb.org/t/p/w780/obKmfNexgL4ZP5cAmzdL4KbHHYX.jpg", size: CGSize(width: 300, height: 300), cacheType: .memoryCache)
}
