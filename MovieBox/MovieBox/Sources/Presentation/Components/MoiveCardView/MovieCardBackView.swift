//
//  MovieCardBackView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/29/24.
//

import SwiftUI

struct MovieCardBackView: View {
    
    private let movieCard: MovieCard
    private let width: CGFloat
    private let height: CGFloat
    private let font: Font
    
    init(movieCard: MovieCard, width: CGFloat, height: CGFloat, font: Font = .body) {
        self.movieCard = movieCard
        self.width = width
        self.height = height
        self.font = font
    }
    
    var body: some View {
        MoviePosterView(width: width, height: height)
            .blur(radius: 10.0)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.5))
                    .frame(width: width, height: height)
                    .overlay {
                        Text(movieCard.comment)
                            .font(font)
                            .foregroundStyle(.white)
                            .rotation3DEffect(
                                .degrees(-180),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: 0.5
                            )
                            .padding()
                    }
            }
    }
    
    @ViewBuilder
    private func MoviePosterView(width: CGFloat, height: CGFloat) -> some View {
        if let imageData = movieCard.poster, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .frame(maxWidth: width, maxHeight: height)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
            EmptyView()
        }
    }
}

#Preview {
    MovieCardBackView(movieCard: MovieCard(movieID: 673, poster: nil, title: "해리포터와 아즈카반", rate: 0, comment: "", creadedAt: .now), width: 350, height: 350 * 1.4, font: .body)
}
