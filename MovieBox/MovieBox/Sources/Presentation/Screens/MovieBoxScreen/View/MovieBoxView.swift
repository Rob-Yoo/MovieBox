//
//  MovieBoxView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/28/24.
//

import SwiftUI
import ShuffleIt
import Combine

//struct C {
//    let index: Int
//    let color: Color
//}
//
//struct MovieBoxView: View {
//
//    @StateObject private var viewModel = MovieBoxViewModel()
//    @State private var currentIndex = 0
//    @State private var flippedStates: [Int: Bool] = [:] // 각 카드에 대한 회전 상태 저장
//
//    let colors: [C] = [
//        C(index: 0, color: .blue),
//        C(index: 1, color: .red)
//    ]
//
//    var body: some View {
//        ShuffleDeck(
//            colors,
//            initialIndex: 0
//        ) { c in
//            test(c: c)
//        }
//        .onShuffleDeck { context in
//            self.currentIndex = context.index
//        }
//    }
//
//    @ViewBuilder
//    func test(c: C) -> some View {
//        let isFlipped = flippedStates[c.index] ?? false // 카드별 회전 상태
//
//        ZStack {
//            if isFlipped {
//                Color.green
//                    .frame(width: 200, height: 300)
//                    .cornerRadius(16)
//            } else {
//                c.color
//                    .frame(width: 200, height: 300)
//                    .cornerRadius(16)
//                    .rotation3DEffect(
//                        .degrees(isFlipped ? 180 : 0), // 앞면일 때는 0도
//                        axis: (x: 0, y: 1, z: 0),
//                        perspective: 0.5
//                    )
//                    .animation(.easeInOut(duration: 0.5), value: isFlipped) // 애니메이션
//            }
//        }
//        .onTapGesture {
//            withAnimation {
//                flippedStates[c.index] = !isFlipped
//            }
//        }
//    }
//}

struct MovieBoxView: View {
    
    @StateObject private var viewModel = MovieBoxViewModel()
    @State private var isShowItems: Bool = false
    @State private var isFlipped: Bool = false
    @State private var index = 0
    @State private var flippedStates: [Int: Bool] = [:] // 각 카드에 대한 회전 상태 저장
    
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
        
        VStack {
            if isFlipped {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        Rectangle()
                            .fill(Color.background)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(0.7)
                            .overlay {
                                
                                Text(movieCard.comment)
                                    .rotation3DEffect(
                                        .degrees(-180),
                                        axis: (x: 0, y: 1, z: 0),
                                        perspective: 0.5
                                    )
                                    .foregroundStyle(.white)
                                    .padding()
                            }
                    }
            } else {
                MovieCardView(
                    movieCard: MovieCard(movieID: movieCard.movieID, poster: movieCard.poster, title: movieCard.title, rate: movieCard.rate, comment: movieCard.comment, creadedAt: movieCard.createdAt),
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
