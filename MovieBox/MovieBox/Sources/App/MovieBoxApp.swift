//
//  MovieBoxApp.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/19/24.
//

import SwiftUI
import UIKit
@main
struct MovieBoxApp: App {
    @Environment(\.scenePhase) var scenePhase

    init() {
        let tabAp = UITabBarAppearance()
        
        tabAp.backgroundColor = .clear
        UITabBar.appearance().standardAppearance = tabAp
        UITabBar.appearance().scrollEdgeAppearance = tabAp
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        
        let navAp1 = UINavigationBarAppearance()
        let navAp2 = UINavigationBarAppearance()
        
        navAp1.configureWithTransparentBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = navAp1
        navAp2.configureWithOpaqueBackground()
        navAp2.backgroundColor = .background
        UINavigationBar.appearance().standardAppearance = navAp2
        
        ImageCacheManager.shared.loadDiskCacheState()
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                ImageCacheManager.shared.saveDiskCacheState()
            default:
                break
            }
        }
    }
}

