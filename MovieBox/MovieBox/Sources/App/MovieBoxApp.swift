//
//  MovieBoxApp.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/19/24.
//

import SwiftUI
import UIKit
import RealmSwift

@main
struct MovieBoxApp: App {

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
        
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    var body: some Scene {
        WindowGroup {
            CustomTabView()
        }
    }
}

