//
//  InjectedStateObject.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/23/24.
//

import SwiftUI
import Foundation

@propertyWrapper
struct InjectedStateObject<T: ObservableObject>: DynamicProperty {
    @StateObject private var stateObject: T
    
    var wrappedValue: T { stateObject }
    
    var projectedValue: ObservedObject<T>.Wrapper { $stateObject }
    
    init() {
        let resolvedObject = DIContainer.shared.container.resolve(T.self)!
        _stateObject = StateObject(wrappedValue: resolvedObject)
    }
}
