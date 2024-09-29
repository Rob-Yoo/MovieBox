//
//  ViewModel.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/23/24.
//

import Foundation

protocol ViewModel: ObservableObject, AnyObject {
    associatedtype Input
    associatedtype Output

    var input: Input { get set }
    var output: Output { get set }
    func transform()
}
