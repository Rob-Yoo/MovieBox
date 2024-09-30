//
//  CustomTabView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import SwiftUI
import UIKit

struct CustomTabView: View {
    
    @State private var activeTab: Tab = .box
    
    init() {}
    
    var body: some View {
        TabView(selection: $activeTab) {
            
            ForEach(Tab.allCases, id: \.hashValue) { tab in
                tab.rootView
                    .tag(tab)
                    .tabItem {
                        tab.tabBarImage
                    }
            }
            
        }
        .tint(Color.white)
    }
}

extension CustomTabView {
    enum Tab: CaseIterable {
        case box
        case movie
        case setting
        
        var tabBarImage: Image {
            switch self {
            case .box:
                return Image(systemName: "shippingbox.fill")
            case .movie:
                return Image(systemName: "movieclapper.fill")
            case .setting:
                return Image(systemName: "gearshape.fill")
            }
        }
        
        var rootView: some View {
            switch self {
            case .box:
                return AnyView(MovieBoxView())
            case .movie:
                return AnyView(MovieListView())
            case .setting:
                return AnyView(SettingView())
            }
        }
    }
}

#Preview {
    CustomTabView()
}
