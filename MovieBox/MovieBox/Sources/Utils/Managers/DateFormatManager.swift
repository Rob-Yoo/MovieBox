//
//  DateFormatManager.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation

final class DateFormatManager {
    static let shared = DateFormatManager()
    private let dateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter
    }()
    
    func convertToString(format: String = "yyyyMMdd", target: Date) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: target)
    }
}
