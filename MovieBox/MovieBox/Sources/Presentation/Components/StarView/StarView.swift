//
//  StarView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/27/24.
//

import SwiftUI
import Cosmos

struct StarView: UIViewRepresentable {
    var rating: Double
    var starSize: Double
    var isTouchable: Bool
    
    init(rating: Int, starSize: Double = 40, isTouchable: Bool = true) {
        self.rating = Double(rating)
        self.starSize = starSize
        self.isTouchable = isTouchable
    }

    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        uiView.settings.filledColor = .systemYellow
        uiView.settings.emptyColor = .lightGray
        uiView.settings.emptyBorderColor = .clear
        uiView.settings.updateOnTouch = isTouchable

        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        uiView.settings.starSize = starSize
    }

}
