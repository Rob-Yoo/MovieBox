//
//  MovieListView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import SwiftUI
import NukeUI

struct MovieListView: View {
    
    @InjectedStateObject private var viewModel: MovieListViewModel
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { geometry in
                
                VStack(spacing: 0) {
                    
                    ExpandableSearchBar(viewModel: viewModel)
                        .padding(.vertical)
                    
                    Spacer()
                    
                    if viewModel.output.showSearchView {
                        
                        if (viewModel.output.searchResults.isEmpty) {
                            VStack {
                               Text("검색 결과가 없습니다.")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .frame(maxHeight: .infinity)
                            .padding(.bottom, 50)
                        }
                        else {
                            ScrollView {
                                
                                HStack {
                                    Text("검색 결과")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .padding(.leading)
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())], spacing: 10) {
                                        ForEach(viewModel.output.searchResults, id: \.self) { movie in
                                            
                                            let width = (geometry.size.width - 60) / 3
                                            
                                            NavigationLink {
                                                NextView(id: movie.id)
                                            } label: {
                                                LazyImage(url: URL(string: movie.posterPath)!) { state in
                                                    if let image = state.image {
                                                        image
                                                            .resizable()
                                                            .frame(width: width, height: width * 1.3)
                                                    } else {
                                                        ImagePlaceholderView(width: width, height: width * 1.3)
                                                    }
                                                }
                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                            }
                                            
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                            }
                            .scrollIndicators(.never)
                        }

                    } else {
                        List {
                            Section {
                                ForEach(viewModel.output.weeklyTrendMovieList, id: \.id) { item in
                                    ZStack(alignment: .leading) {
                                        weeklyTrendMovieItemView(item, geometry.size.width)
                                        NavigationLink { NextView(id: item.id)
                                            } label: {
                                                EmptyView()
                                            }
                                            .opacity(0)
                                    }
                                    .listRowBackground(Color.clear)
                                }
                            } header: {
                                Text("주간 인기 영화")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                            .listSectionSeparator(.hidden)
                        }
                        .padding(.trailing)
                        .scrollIndicators(.never)
                        .listStyle(.grouped)
                        .scrollContentBackground(.hidden)
                    }
                    
                }
                .task {
                    viewModel.input.loadWeeklyTrendMovieList.send(())
                }
                .background(Color.background)
            }
        }
    }
    
    func weeklyTrendMovieItemView(_ movie: WeeklyTrendMovieGallery.WeeklyTrendMovie, _ screenWidth: CGFloat) -> some View {

        let width = screenWidth * 0.2
        
        return HStack(spacing: 20) {
            
            LazyImage(url: URL(string: movie.posterPath)!) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .frame(width: width, height: width * 1.3)
                } else {
                    ImagePlaceholderView(width: width, height: width * 1.3)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            
            VStack(alignment: .leading, spacing: 5) {
                
                Text(movie.name)
                    .font(.body)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                
                Text(movie.releaseYear)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

struct NextView: View {
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var body: some View {
        Text(id.formatted())
    }
}

//struct Movie

#Preview {
    MovieListView()
}