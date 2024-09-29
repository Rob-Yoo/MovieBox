//
//  ExpandableSearchBar.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/23/24.
//

import SwiftUI

struct ExpandableSearchBar: View {
    
    @ObservedObject var viewModel: MovieListViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            
            if (!viewModel.output.showSearchView) {
                Text("영화")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            Spacer(minLength: 0)
            
            HStack(spacing: 0) {
                
                if viewModel.output.showSearchView {
                    
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 8)
                    
                    TextField("영화를 검색해보세요.", text: $viewModel.input.searchTextField)
                        .foregroundStyle(.white)
                        .background(Color.gray)
                        .onSubmit {
                            viewModel.input.showActivityIndicator.send(true)
                            viewModel.input.searchButtonTapped.send(())
                        }
                    
                    Button {
                        withAnimation {
                            viewModel.input.showSearchView.send(false)
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .padding(.trailing, 8)
                    }
                } else {
                    Button {
                        withAnimation {
                            viewModel.input.showSearchView.send(true)
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                            .padding(10)
                    }
                    .clipShape(Circle())
                }
                
            }
            .padding(viewModel.output.showSearchView ? 10 : 0)
            .background(Color.gray)
            .clipShape(Capsule())

        }
        .padding(.horizontal)
    }
}

#Preview {
    ExpandableSearchBar(
        viewModel: DIContainer.shared.container.resolve(MovieListViewModel.self)!
    )
}
