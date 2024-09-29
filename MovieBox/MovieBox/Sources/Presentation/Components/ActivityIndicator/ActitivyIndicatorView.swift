//
//  ActitivyIndicatorView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/30/24.
//

import SwiftUI

struct ActitivyIndicatorView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.8))
            .frame(width: 100, height: 100)
            .overlay {
                ProgressView()
                    .scaleEffect(1.6)
            }
    }
}

#Preview {
    ActitivyIndicatorView()
}
