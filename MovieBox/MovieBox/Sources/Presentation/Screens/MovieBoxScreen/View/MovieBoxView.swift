//
//  MovieBoxView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/28/24.
//

import SwiftUI
import ShuffleIt

struct MovieBoxView: View {
    
    @StateObject private var viewModel = MovieBoxViewModel()
    @State private var isShowItems: Bool = false
    @State private var isFlipped: Bool = false
    @State private var index = 0
    @State private var flippedStates: [Int: Bool] = [:]
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            VStack(spacing: 10) {
                
                let width = screenWidth * 0.75
                
                HStack {
                    Text("무비 박스")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.top)
                
                if (viewModel.output.movieCardList.isEmpty) {
                    EmptyView()
                } else {
                    ShuffleDeck(
                        viewModel.output.movieCardList.reversed(),
                        initialIndex: 0
                    ) { movieCard in
                        CardView(movieCard: movieCard, width: width, height: width * 1.5)
                    }
                    .onShuffleDeck { context in
                        self.index = context.index
                    }
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.input.loadMovieCardList.send(())
            }
            .background(Color.background)
        }
    }
    
    @ViewBuilder
    func CardView(movieCard: MovieBoxCard, width: CGFloat, height: CGFloat) -> some View {
        let isFlipped = flippedStates[movieCard.index] ?? false
        let card = MovieCard(movieID: movieCard.movieID, poster: movieCard.poster, title: movieCard.title, rate: movieCard.rate, comment: movieCard.comment, creadedAt: movieCard.createdAt)
        
        VStack {
            if isFlipped {
                MovieCardBackView(
                    movieCard: card,
                    width: width,
                    height: height,
                    font: .body
                )
            } else {
                MovieCardFrontView(
                    movieCard: card,
                    width: width,
                    height: height,
                    starSize: 30
                )
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .onTapGesture {
            withAnimation {
                flippedStates[movieCard.index] = !isFlipped
            }
        }
    }

}

#Preview {
    MovieBoxView()
}
