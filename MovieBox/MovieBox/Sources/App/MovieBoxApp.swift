//
//  MovieBoxApp.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/19/24.
//

import SwiftUI

@main
struct MovieBoxApp: App {
    
    init() {
        let tabAp = UITabBarAppearance()
        
        tabAp.configureWithOpaqueBackground()
        tabAp.backgroundColor = .mainTheme
        UITabBar.appearance().standardAppearance = tabAp
        UITabBar.appearance().scrollEdgeAppearance = tabAp
        
        let navAp1 = UINavigationBarAppearance()
        let navAp2 = UINavigationBarAppearance()
        
        navAp1.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navAp1
        navAp2.configureWithOpaqueBackground()
        navAp2.backgroundColor = .background
        UINavigationBar.appearance().standardAppearance = navAp2
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
        }
    }
}
