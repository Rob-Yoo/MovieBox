//
//  ImageDetailView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 12/10/24.
//

import SwiftUI
import UIKit.UIImage

struct ImageDetailView: View {

    private let imagePath: String?
    private let width: CGFloat
    let onClose: () -> Void
    @State private var imageData: Data? = nil
    
    init(imagePath: String?, width: CGFloat, onClose: @escaping () -> Void, imageData: Data? = nil) {
        self.imagePath = imagePath
        self.width = width
        self.onClose = onClose
        self.imageData = imageData
    }
    
    var body: some View {
        NavigationStack {

            VStack(alignment: .center) {
                
                if let data = imageData, let uiImage = UIImage(data: data) {
                    let ratio = uiImage.size.width / uiImage.size.height
                    let targetSize = CGSize(width: width, height: width / ratio)
                    let render = UIGraphicsImageRenderer(size: targetSize)
                    let resizedImage = render.image { image in
                        uiImage.draw(in: CGRect(origin: .zero, size: targetSize))
                    }
                    
                    Image(uiImage: resizedImage)
                        .scaledToFit()
                } else {
                    ProgressView()
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
            .task {
                imageData = await ImageCacheManager.shared.getImage(imagePath ?? "", .all)
            }
            
        }
    }
}
