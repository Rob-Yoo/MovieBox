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
    
    init() {
        let appearance = UITabBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainTheme
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
//        let navBarAppearance = UINavigationBarAppearance()
//                    
//        // 뒤로 가기 버튼의 텍스트 제거
//        navBarAppearance.setBackIndicatorImage(UIImage(systemName: "chevron.left"), transitionMaskImage: UIImage(systemName: "chevron.left"))
//        navBarAppearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: -1000, vertical: 0)
//        navBarAppearance.backgroundColor = .background
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
    
    var body: some View {
        TabView(selection: $activeTab) {
            
            ForEach(Tab.allCases, id: \.hashValue) { tab in
                tab.rootView
                    .tag(tab)
                    .tabItem { tab.tabBarImage }
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
                return Image(systemName: "movieclapper")
            case .setting:
                return Image(systemName: "gearshape")
            }
        }
        
        var rootView: some View {
            switch self {
            case .box:
                return AnyView(MovieBoxView())
            case .movie:
                return AnyView(MovieListView()
                    .background(Color.background))
            case .setting:
                return AnyView(SimpleView()
                    .background(Color.background))
            }
        }
    }
}

struct SimpleView: View {
    var body: some View {
        return Text("공사중...")
    }
}

#Preview {
    CustomTabView()
}
