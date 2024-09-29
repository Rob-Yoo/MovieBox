//
//  ImagePlaceholderView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/25/24.
//

import SwiftUI

struct ImagePlaceholderView: View {
    private let width: CGFloat
    private let height: CGFloat
    
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
            .overlay {
                
                Image(systemName: "popcorn.fill")
                    .font(.title)
                    .tint(Color.white)
                
            }
    }
}

#Preview {
    ImagePlaceholderView(width: 100, height: 100 * 1.3)
}
