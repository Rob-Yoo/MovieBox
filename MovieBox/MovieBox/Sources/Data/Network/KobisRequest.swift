//
//  KobisRequest.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Foundation
import Moya

enum KobisRequest {
    case dailyBoxOffice(date: Date)
}

extension KobisRequest: TargetType {
    var baseURL: URL {
        return URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest")!
    }
    
    var path: String {
        switch self {
        case .dailyBoxOffice:
            return "/boxoffice/searchDailyBoxOfficeList.json"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .dailyBoxOffice(let date):
            let parameters = [
                "key": API.kobisKey,
                "targetDt": DateFormatManager.shared.convertToString(target: date)
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
