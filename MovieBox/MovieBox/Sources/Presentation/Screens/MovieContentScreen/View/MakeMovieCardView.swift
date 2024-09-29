//
//  MakeMovieCardView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import SwiftUI

struct MakeMovieCardView: View {
    
    @StateObject private var viewModel: MakeMovieCardViewModel
    @FocusState private var isFocused
    @Environment(\.dismiss) private var dismiss
    
    init(movieCard: MovieCard) {
        _viewModel = StateObject(wrappedValue: MakeMovieCardViewModel(movieCard: movieCard))
    }
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geometry in
                
                let screenWidth = geometry.size.width
                let _ = geometry.size.height
                
                ScrollView {
                    VStack(spacing: 10) {
                    
                        Divider()
                        
                        StarView(rating: viewModel.output.movieCard.rate)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { gesture in

                                        let starSize: CGFloat = 40
                                        let stars: Double = Double(gesture.location.x / starSize)
                                        let rating = min(max(stars, 0), 5).rounded()
                                        let rate = Int(rating)
                                        
                                        viewModel.input.rate.send(rate)
                                    }
                            )
                            .padding()
                        
                        Divider()
                        
                        TextField("후기를 작성해보세요.", text: $viewModel.input.comment, axis: .vertical)
                            .lineLimit(10...10)
                            .focused($isFocused)
                            .padding(.horizontal)
                        
                        Divider()
                        
                        let width = screenWidth * 0.63
                        
                        MovieCardView(
                            movieCard: viewModel.output.movieCard,
                            width: width,
                            height: width * 1.45,
                            starSize: 25,
                            font: .headline
                        )
                        .padding(.vertical)
                        
                        Spacer()
                        
                    }
                    .padding(.vertical)
                    .onTapGesture {
                        isFocused = false
                    }
                }
                .background(Color.background)
                .scrollIndicators(.never)
                .navigationTitle("영화 카드 제작")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
                .toolbar(.visible, for: .navigationBar)
                .toolbar(content: {
                    Button {
                        viewModel.input.saveMovieCard.send(())
                        dismiss()
                    } label: {
                        
                        let saveButtonLabel = viewModel.output.isEditing ? "수정" : "저장"
                        let saveButtonColor = viewModel.output.isValidate ? Color.mainTheme : Color.gray

                        Text(saveButtonLabel)
                            .fontWeight(.bold)
                            .foregroundStyle(saveButtonColor)
                    }
                    .disabled(!viewModel.output.isValidate)
                })
            }

        }
        
    }
}

#Preview {
    MakeMovieCardView(movieCard: MovieCard(movieID: 673, poster: nil, title: "해리포터와 아즈카반", rate: 0, comment: "", creadedAt: .now))
}
