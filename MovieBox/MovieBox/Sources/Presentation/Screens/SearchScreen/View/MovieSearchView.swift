//
//  MovieSearchView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import SwiftUI
import NukeUI

struct MovieSearchView: View {
    
    @InjectedStateObject private var viewModel: MovieSearchViewModel
    @State private var show = false
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 0) {
                
                ExpandableSearchBar(viewModel: viewModel)
                    .padding(.vertical)

                Spacer()
                
                List {
                    Section {
                        ForEach(viewModel.output.weeklyTrendMovieList, id: \.id) { item in
                            ZStack(alignment: .leading) {
                                weeklyTrendMovieItemView(item)
                                NavigationLink(
                                    destination: { NextView(id: item.id)
                                    }
                                , label: {})
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
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
            }
            .task {
                viewModel.input.loadWeeklyTrendMovieList.send(())
            }
            .background(Color.background)
        }
    }
    
    func weeklyTrendMovieItemView(_ movie: WeeklyTrendMovieGallery.WeeklyTrendMovie) -> some View {
        
        let request = ImageRequest(
            url: URL(string: movie.posterPath)!,
            userInfo: [.scaleKey: 12]
        )
        
        return HStack(spacing: 20) {
            
            LazyImage(request: request)
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
    MovieSearchView()
}
