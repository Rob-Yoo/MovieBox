//
//  ExpandableSearchBar.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/23/24.
//

import SwiftUI

struct ExpandableSearchBar: View {
    
    @ObservedObject var viewModel: MovieSearchViewModel
    @State private var show = false
    
    var body: some View {
        HStack(spacing: 0) {
            
            if (!show) {
                Text("영화")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            Spacer(minLength: 0)
            
            HStack(spacing: 0) {
                
                if self.show {
                    
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing, 8)
                    
                    TextField("영화를 검색해보세요.", text: $viewModel.input.searchTextField)
                        .foregroundStyle(.white)
                        .background(Color.gray)
                        .onSubmit {
                            //
                        }
                    
                    Button {
                        withAnimation {
                            self.show.toggle()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .padding(.trailing, 8)
                    }
                } else {
                    Button {
                        withAnimation {
                            self.show.toggle()
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                            .padding(10)
                    }
                    .clipShape(Circle())
                }
                
            }
            .padding(self.show ? 10 : 0)
            .background(self.show ? Color.gray : Color.mainTheme)
            .clipShape(Capsule())

        }
        .padding(.horizontal)
    }
}

#Preview {
    ExpandableSearchBar(
        viewModel: DIContainer.shared.container.resolve(MovieSearchViewModel.self)!
    )
}
