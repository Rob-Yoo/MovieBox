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
    @State private var willRemovingStates: [Int: Bool] = [:]
    @State private var showAlert = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let screenWidth = geometry.size.width
            let _ = geometry.size.height
            
            ZStack {
                
                let width = screenWidth * 0.75
                
                VStack {
                    
                    HStack {
                        Text("무비 박스")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        if !(viewModel.output.movieCardList.isEmpty) {
                            Button {
                                withAnimation {
                                    viewModel.input.isRemovingMode.send(true)
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                            }
                            .disabled(viewModel.output.isRemovingMode)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Spacer()
                }
                
                if (viewModel.output.movieCardList.isEmpty) {
                    VStack(spacing: 50) {
                        
                        VStack(spacing: -20) {
                            Image("MovieBoxIcon")
                                .resizable()
                                .frame(width: 200, height: 200)
                            
                            Text("무비 박스 사용법")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("🍿 보관하고 싶은 영화를 검색")
                            Text("🍿 나만의 코멘트를 작성하여 카드 제작")
                            Text("🍿 카드 덱을 뒤적거리며 추억 되살리기")
                        }
                        .font(.headline)
                        .fontWeight(.thin)
                    }
                    .padding(.bottom, 100)
                } else {
                    
                    if viewModel.output.isRemovingMode {
                        
                        VStack {
                            
                            ScrollView(.horizontal) {
                                
                                HStack(spacing: 10) {
                                    ForEach(viewModel.output.movieCardList, id: \.movieID) { card in
                                        
                                        RemovableMovieCardView(card, width: width, height: width * 1.5)
                                        
                                    }
                                }
                                .padding(.leading, (screenWidth / 2) - (width / 2))
                                .padding(.trailing, (screenWidth / 2) - (width / 2))
                                
                            }
                            .scrollIndicators(.never)

                        }
                    }
                    else {
                        ShuffleDeck(
                            viewModel.output.movieCardList,
                            initialIndex: 0
                        ) { movieCard in
                            CardView(movieCard: movieCard, width: width, height: width * 1.5)
                        }
                        .onShuffleDeck { context in
                            self.index = context.index
                        }
                    }
                }
            }
            .onAppear {
                viewModel.input.loadMovieCardList.send(())
            }
            .alert("영화 카드를 정말 삭제하시겠어요?", isPresented: $showAlert) {
                Button("취소", role: .cancel) {
                    showAlert = false
                }
                
                Button("삭제", role: .destructive) {
                    viewModel.input.removeMovieCardsTrigger.send(())
                    willRemovingStates.removeAll()
                }
            }
            .toolbar(viewModel.output.isRemovingMode ? .hidden : .visible, for: .tabBar)
            .toolbar {
                
                if (viewModel.output.isRemovingMode) {
                    ToolbarItemGroup(placement: .bottomBar) {
                        
                        Button {
                            withAnimation {
                                willRemovingStates.removeAll()
                                viewModel.input.isRemovingMode.send(false)
                            }
                        } label: {
                            Text("취소")
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        Text("\(viewModel.output.removingListCount)개의 카드가 선택됨")
                        
                        Spacer()
                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
                
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

    func RemovableMovieCardView(_ card: MovieBoxCard, width: CGFloat, height: CGFloat) -> some View {
        
        let willRemovingState = willRemovingStates[card.index] ?? false
        
        return CardView(movieCard: card, width: width, height: height)
            .overlay {
                
                ZStack {
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    let cWidth = width * 0.2
                    
                    if (willRemovingState) {
                        
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: cWidth, height: cWidth)
                            .onTapGesture {
                                
                                viewModel.input.removeRemovingList.send(card.movieID)
                                
                                withAnimation {
                                    willRemovingStates[card.index] = false
                                }
                            }
                        
                    }
                    else {
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 0.8)
                            .frame(width: cWidth, height: cWidth)
                            .background(Color.black.opacity(0.62).clipShape(Circle()))
                            .onTapGesture {
                                
                                viewModel.input.addRemovingList.send(card.movieID)
                                
                                withAnimation {
                                    willRemovingStates[card.index] = true
                                }
                            }
                        
                    }
                }
                
            }
    }
}

#Preview {
    MovieBoxView()
}
