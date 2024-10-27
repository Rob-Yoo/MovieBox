//
//  MovieContentView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/24/24.
//

import SwiftUI
import YouTubePlayerKit

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct MovieContentView: View {
    
    @StateObject private var viewModel: MovieContentViewModel
    private var output: MovieContentViewModel.Output {
        return viewModel.output
    }
    @State private var shouldExpand = false
    @State private var showExpandingButton = false
    @State private var isAtTop = true
    @Environment(\.dismiss) private var dismiss
    
    init(movieID: Int) {
        _viewModel = StateObject(wrappedValue: MovieContentViewModel(movieID: movieID))
    }
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geometry in
                
                let screenWidth = geometry.size.width
                let _ = geometry.size.height
                
                ZStack {
                    
                    ScrollView {
                        
                        LazyVStack {
                            
                            MovieContentHeaderView(viewModel: viewModel, screenSize: geometry.size)
                            
                            Spacer()
                            
                            if !(output.movieInfo.overview.isEmpty) {
                                VStack {
                                    
                                    HStack {
                                        
                                        Text("줄거리")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                    }
                                    .padding()
                                    
                                    
                                    Text("\(output.movieInfo.overview)")
                                        .font(.headline)
                                        .fontWeight(.thin)
                                        .lineLimit(shouldExpand ? nil : 3)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal)
                                        .background(
                                            ViewThatFits(in: .vertical) {
                                                Text("\(output.movieInfo.overview)")
                                                    .font(.headline)
                                                    .fontWeight(.thin)
                                                    .padding(.horizontal)
                                                    .hidden()
                                                Color.clear
                                                    .onAppear { showExpandingButton = true }
                                            }
                                        )

                                    if (showExpandingButton) {
                                        Button {
                                            withAnimation(.easeInOut) {
                                                shouldExpand.toggle()
                                            }
                                        } label: {
                                            let imageName = shouldExpand ? "chevron.up" : "chevron.down"
                                            
                                            Image(systemName: imageName)
                                                .foregroundStyle(Color.background)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .padding(12)
                                        }
                                        .background(.white)
                                        .clipShape(Circle())
                                        .padding(.vertical, 10)
                                    }

                                }
                                .padding(.top)
                            }
                            
                            if !(output.movieCredit.castList.isEmpty) {
                                VStack {
                                    
                                    HStack {
                                        
                                        Text("출연")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                    }
                                    .padding()
                                    
                                    
                                    ScrollView(.horizontal) {
                                        
                                        LazyHStack(spacing: 10) {
                                            
                                            ForEach(output.movieCredit.castList.prefix(10), id: \.self) { cast in
                                                
                                                let width = screenWidth * 0.22
                                                
                                                VStack(spacing: 10) {
                                                    
                                                    AsyncCachableImageView(urlString: cast.profilePath, size: CGSize(width: width, height: width * 1.32))
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    
                                                    Text("\(cast.name)")
                                                        .font(.caption)
                                                        .fontWeight(.light)
                                                        .foregroundStyle(.white)
                                                        .lineLimit(1)
                                                    
                                                }
                                                .frame(maxWidth: width)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    .scrollIndicators(.never)
                                }
                                .padding(.vertical)
                            }
                            
                            if !(output.movieImageGallery.backdropPathList.isEmpty) {
                                VStack {
                                    
                                    HStack {
                                        
                                        Text("갤러리")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                    }
                                    .padding()
                                    
                                    
                                    ScrollView(.horizontal) {
                                        
                                        LazyHStack(spacing: 10) {
                                            
                                            ForEach(output.movieImageGallery.backdropPathList.prefix(10), id: \.self) { movieImage in
                                                
                                                let width = screenWidth * 0.5
                                                
                                                AsyncCachableImageView(
                                                    urlString: movieImage,
                                                    size: CGSize(width: width, height: width * 0.7)
                                                )
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                            }
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    .scrollIndicators(.never)
                                }
                                .padding(.vertical)
                                
                            }
                            
                            if !(output.movieVideoGallery.isEmpty) {
                                VStack {
                                    
                                    HStack {
                                        
                                        Text("동영상")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                    }
                                    .padding()
                                    
                                    
                                    ScrollView(.horizontal) {
                                        
                                        LazyHStack(spacing: 10) {
                                            
                                            ForEach(output.movieVideoGallery, id: \.self) { video in
                                                
                                                let width = screenWidth * 0.7
                                                let youTubePlayer = YouTubePlayer(stringLiteral: video.videoPath)
                                                
                                                VStack(alignment: .leading, spacing: 10) {
                                                    
                                                    YouTubePlayerView(youTubePlayer) { state in
                                                        switch state {
                                                        case .idle:
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(.gray.opacity(0.3))
                                                                
                                                                ProgressView()
                                                            }
                                                        case .ready:
                                                            EmptyView()
                                                        case .error:
                                                            ZStack {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(.gray)
                                                                
                                                                Image(systemName: "play.slash.fill")
                                                                    .font(.title)
                                                            }
                                                        }
                                                    }
                                                    .frame(width: width, height: width * 0.6)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    
                                                    Text("\(video.title)")
                                                        .font(.callout)
                                                        .foregroundStyle(.white)
                                                        .padding(.leading, 2)
                                                        .lineLimit(1)
                                                }
                                                .frame(maxWidth: width)
                                            }
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    .scrollIndicators(.never)
                                }
                                .padding(.vertical)
                            }

                            if !(output.similarMovies.posterList.isEmpty) {
                                VStack {
                                    
                                    HStack {
                                        
                                        Text("비슷한 영화")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                    }
                                    .padding()
                                    
                                    
                                    ScrollView(.horizontal) {
                                        
                                        LazyHStack(spacing: 10) {
                                            
                                            ForEach(output.similarMovies.posterList.prefix(10), id: \.self) { movie in
                                                
                                                let width = screenWidth * 0.22
                                                
                                                NavigationLink {
                                                    MovieContentView(movieID: movie.id)
                                                } label: {
                                                    AsyncCachableImageView(
                                                        urlString: movie.posterPath,
                                                        size: CGSize(width: width, height: width * 1.32)
                                                    )
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    .scrollIndicators(.never)
                                }
                                .padding(.vertical)
                            }
                            
                            if !(output.recommendMovies.posterList.isEmpty) {
                                VStack {
                                    
                                    HStack {
                                        
                                        Text("추천 영화")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                    }
                                    .padding()
                                    
                                    
                                    ScrollView(.horizontal) {
                                        
                                        LazyHStack(spacing: 10) {
                                            
                                            ForEach(output.recommendMovies.posterList.prefix(10), id: \.self) { movie in
                                                
                                                let width = screenWidth * 0.22
                                                
                                                NavigationLink {
                                                    MovieContentView(movieID: movie.id)
                                                } label: {
                                                    AsyncCachableImageView(
                                                        urlString: movie.posterPath,
                                                        size: CGSize(width: width, height: width * 1.32)
                                                    )
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal)
                                    .scrollIndicators(.never)
                                }
                                .padding(.vertical)
                            }
                            
                        }
                        .padding(.bottom)
                        .overlay(alignment: .top) {
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .global).origin.y)
                            }
                            .frame(height: 0)
                        }
                    }
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        isAtTop = value >= 0
                    }
                    .background(Color.background)
                    .ignoresSafeArea(edges: .top)
                    .toolbar(.hidden, for: .tabBar)
                    
                    HStack {
                     
                        Spacer()
                        
                        VStack(spacing: 10) {
                            
                            Spacer()

                            NavigationLink {
                                MakeMovieCardView(movieCard: viewModel.output.movieCard)
                            } label: {
                                Image(systemName: "pencil.and.list.clipboard")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(20)
                            }
                            .background(Color.mainTheme)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.8), radius: 5, x: 2, y: 2)
                            .opacity(viewModel.output.movieCard.poster == nil ? 0 : 1)
                            .disabled(viewModel.output.movieCard.poster == nil)
                        }
                        .padding(.bottom, 30)
                        .padding(.trailing, 15)
                    }
                    
                    if (viewModel.output.showActivityIndicator) {
                        ActitivyIndicatorView()
                    }
                }
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                        }
                    }
                }
                .navigationTitle(isAtTop ? "" : viewModel.output.movieInfo.title)
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
                .onAppear {
                    viewModel.input.reloadMovieCard.send(())
                }
            }
        }
    }
}

struct MovieContentHeaderView: View {
    
    @ObservedObject private var viewModel: MovieContentViewModel
    private var output: MovieContentViewModel.Output {
        return viewModel.output
    }
    private var screenWidth: CGFloat
    private var screenHeight: CGFloat
    
    init(
        viewModel: MovieContentViewModel,
        screenSize: CGSize
    ) {
        self.viewModel = viewModel
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            let _ = screenWidth
            let height = screenHeight * 0.37

            AsyncCachableImageView(
                urlString: output.movieInfo.backdropPath,
                size: CGSize(width: screenWidth, height: height)
            )
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.05), .black.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: screenWidth, height: height)
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom, spacing: 10) {
                    
                    let width = screenWidth * 0.22
                    
                    AsyncCachableImageView(
                        urlString: output.movieInfo.posterPath,
                        size: CGSize(width: width, height: width * 1.32)
                    )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.leading, 15)

                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text(output.movieInfo.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(output.movieInfo.subHeadlineInfo)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()

                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    MovieContentView(movieID: 673)
}
