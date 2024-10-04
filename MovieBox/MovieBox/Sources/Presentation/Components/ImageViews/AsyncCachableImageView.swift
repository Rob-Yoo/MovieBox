//
//  AsyncCachableImageView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 10/4/24.
//

import SwiftUI

struct AsyncCachableImageView: View {
    @State private var imageData: Data?
    private let imageCacheManager = ImageCacheManager.shared
    private var urlString: String
    private let size: CGSize
    
    init(urlString: String, size: CGSize) {
        self.size = size
        self.urlString = urlString
    }
    
    var body: some View {
        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: size.width, height: size.height)
            } else {
                ImagePlaceholderView(width: size.width, height: size.height)
            }
        }
        .task {
            if let data = await imageCacheManager.getImage(urlString) {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }
    }
}

#Preview {
    AsyncCachableImageView(urlString: "https://image.tmdb.org/t/p/w780/obKmfNexgL4ZP5cAmzdL4KbHHYX.jpg", size: CGSize(width: 300, height: 300))
}
