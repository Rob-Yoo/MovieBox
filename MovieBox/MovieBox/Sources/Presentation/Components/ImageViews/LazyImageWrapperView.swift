//
//  LazyImageWrapperView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import SwiftUI
import NukeUI

struct LazyImageWrapperView: View {
    
    private let urlString: String?
    private let size: CGSize
    private var imageRequest: ImageRequest {
        ImageRequest(url: URL(string: urlString ?? ""), options: .disableMemoryCache)
    }
    
    init(urlString: String, size: CGSize) {
        self.urlString = urlString
        self.size = size
    }
    
    var body: some View {
        LazyImage(request: imageRequest) { state in
            if let image = state.image {
                image
                    .resizable()
                    .frame(width: size.width, height: size.height)
            } else {
                ImagePlaceholderView(width: size.width, height: size.height)
            }
        }
    }
}
