//
//  MovieContentView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/24/24.
//

import SwiftUI
import YouTubePlayerKit

struct MovieContentView: View {
    
    private var movieID: Int
    @InjectedStateObject private var viewModel: MovieContentViewModel
    private var output: MovieContentViewModel.Output {
        return viewModel.output
    }
    
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height

            ScrollView {
                
                LazyVStack {
                    
                    MovieContentHeaderView(viewModel: viewModel, screenSize: geometry.size)
                    
                    Spacer()
                    
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
                                            
                                            LazyImageWrapperView(urlString: cast.profilePath, size: CGSize(width: width, height: width * 1.32))
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
                                        
                                        let width = screenWidth * 0.4
                                        
                                        LazyImageWrapperView(urlString: movieImage, size: CGSize(width: width, height: width * 0.8))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                }
                                
                            }
                            .padding(.horizontal)
                            .scrollIndicators(.never)
                        }
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
                    }
                    

                }
                .padding(.bottom)
                
            }
            .background(Color.background)
            .ignoresSafeArea(edges: .top)
        }
        .task {
            viewModel.input.loadMovieContent.send(movieID)
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
        ZStack {
            LazyImageWrapperView(urlString: output.movieInfo.backdropPath, size: CGSize(width: screenWidth, height: screenHeight * 0.45))
            
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom, spacing: 10) {
                    
                    let width = screenWidth * 0.22
                    
                    LazyImageWrapperView(urlString: output.movieInfo.posterPath, size: CGSize(width: width, height: width * 1.32))
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
