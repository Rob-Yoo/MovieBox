//
//  Country.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/20/24.
//

import Foundation

final class CountryMapper {
    
    private struct Country: Decodable {
        let countryCode: String
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case countryCode = "iso_3166_1"
            case name = "native_name"
        }
    }
    
    static private let countryDictionary: [String: String] = {
        if let path = Bundle.main.path(forResource: "Countries", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                let countries = try JSONDecoder().decode([Country].self, from: jsonData)
                let countryDictionary = Dictionary(uniqueKeysWithValues: countries.map { ($0.countryCode, $0.name) })
                
                return countryDictionary
            } catch {
                print(error.localizedDescription)
                return [:]
            }
        }
        else {
            return [:]
        }
    }()
    
    static func covertToName(code: String) -> String {
        return countryDictionary[code] ?? ""
    }
}