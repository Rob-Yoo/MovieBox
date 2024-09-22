//
//  CustomTabView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/22/24.
//

import SwiftUI

struct CustomTabView: View {
    
    @State private var activeTab: Tab = .box
    
    var body: some View {
        TabView(selection: $activeTab) {
            Text("Box")
                .tag(Tab.box)
                .toolbar(.hidden, for: .tabBar)
            
            MovieSearchView()
                .tag(Tab.search)
                .toolbar(.hidden, for: .tabBar)
            
            Text("Setting")
                .tag(Tab.setting)
                .toolbar(.hidden, for: .tabBar)
        }
        customTabBar()
    }
    
    @ViewBuilder
    func customTabBar(_ tint: Color = .white, _ inactiveTint: Color = .secondary) -> some View {
        ZStack {
            Capsule()
            .frame(height: 74)
            .foregroundColor(Color(.mainTheme))
            .shadow(radius: 2)

            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.index) {
                    TabItem(
                        tint: tint,
                        inactiveTint: inactiveTint,
                        tab: $0,
                        activeTab: $activeTab)
                }
            }
        }
        .padding(.horizontal, 30)
//        .padding(.vertical)
    }
}

struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: CustomTabView.Tab
    @Binding var activeTab: CustomTabView.Tab
    
    var body: some View {
        VStack(spacing: 0) {
            tab.tabBarImage
                .foregroundStyle(activeTab == tab ? tint : inactiveTint)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 35)
        .onTapGesture {
            activeTab = tab
        }
    }
}

extension CustomTabView {
    enum Tab: CaseIterable {
        case box
        case search
        case setting
        
        var tabBarImage: some View {
            switch self {
            case .box:
                return Image(.box)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 30, height: 30)
            case .search:
                return Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 25, height: 25)
            case .setting:
                return Image(systemName: "gear")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
        
        var index: Int {
            return Tab.allCases.firstIndex(of: self) ?? 0
        }
    }
}

#Preview {
    CustomTabView()
}
