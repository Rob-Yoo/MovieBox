//
//  MovieCardView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/28/24.
//

import SwiftUI

struct MovieCardFrontView: View {
    
    private let movieCard: MovieCard
    private let width: CGFloat
    private let height: CGFloat
    private let starSize: Double
    private let font: Font
    
    init(movieCard: MovieCard,
         width: CGFloat,
         height: CGFloat,
         starSize: Double = 35,
         font: Font = .title3
    ) {
        self.movieCard = movieCard
        self.width = width
        self.height = height
        self.starSize = starSize
        self.font = font
    }
    
    var body: some View {
        
        MoviePosterView(width: width, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.98)]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    VStack {
                        
                        Spacer()
                        
                        Text(movieCard.title)
                            .font(font)
                            .lineLimit(1)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        StarView(
                            rating: movieCard.rate,
                            starSize: starSize,
                            isTouchable: false
                        )
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
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
    MovieCardFrontView(movieCard: MovieCard(movieID: 673, poster: nil, title: "해리포터와 아즈카반", rate: 0, comment: "", creadedAt: .now), width: 350, height: 350 * 1.4)
}
