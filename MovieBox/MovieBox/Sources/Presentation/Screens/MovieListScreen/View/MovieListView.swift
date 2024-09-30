//
//  MovieListView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import SwiftUI
import Combine
import NukeUI

struct MovieListView: View {
    
    @StateObject private var viewModel = MovieListViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geometry in
                
                ScrollViewReader { proxy in
                    
                    ZStack {
                        
                        VStack(spacing: 0) {
                            
                            ExpandableSearchBar(viewModel: viewModel)
                                .padding(.vertical)
                            
                            Spacer()
                            
                            if viewModel.output.showSearchView {
                                
                                VStack {
                                    
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
                                                    .id(0)
                                                Spacer()
                                            }
                                            LazyVGrid(columns: [
                                                GridItem(.flexible()),
                                                GridItem(.flexible()),
                                                GridItem(.flexible())], spacing: 10) {
                                                    ForEach(viewModel.output.searchResults.indices, id: \.self) { index in
                                                        let movie = viewModel.output.searchResults[index]
                                                        let width = (geometry.size.width - 60) / 3
                                                        
                                                        NavigationLink {
                                                            MovieContentView(movieID: movie.id)
                                                        } label: {
                                                            LazyImageWrapperView(urlString: movie.posterPath, size: CGSize(width: width, height: width * 1.3))
                                                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                                                .onAppear {
                                                                    
                                                                    if (index == viewModel.output.searchResults.count - 5) {
                                                                        viewModel.input.paginationTrigger.send(())
                                                                    }
                                                                }
                                                        }
                                                        
                                                    }
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(.horizontal)
                                                .padding(.bottom)
                                        }
                                        .scrollIndicators(.never)
                                    }
                                    
                                }
                                .onChange(of: viewModel.output.scrollToTop) { value in
                                    if (value) {
                                        proxy.scrollTo(0, anchor: .top)
                                        viewModel.input.scrollToTop.send(false)
                                    }
                                }
                                
                            } else {
                                List {
                                    Section {
                                        ForEach(viewModel.output.weeklyTrendMovieList, id: \.id) { item in
                                            ZStack(alignment: .leading) {
                                                weeklyTrendMovieItemView(item, geometry.size.width)
                                                NavigationLink { MovieContentView(movieID: item.id)
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
                        if (viewModel.output.showActivityIndicator) {
                            ActitivyIndicatorView()
                        }
                    }
                    .task {
                        viewModel.input.loadWeeklyTrendMovieList.send(())
                    }
                    .background(Color.background)
                }
            }
        }
    }
    
    func weeklyTrendMovieItemView(_ movie: WeeklyTrendMovieGallery.WeeklyTrendMovie, _ screenWidth: CGFloat) -> some View {

        let width = screenWidth * 0.2
        
        return HStack(spacing: 20) {
            
            LazyImageWrapperView(urlString: movie.posterPath, size: CGSize(width: width, height: width * 1.3))
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

#Preview {
    MovieListView()
}
