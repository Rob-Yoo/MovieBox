//
//  MoyaProvider+Extension.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/21/24.
//

import Moya

extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}

extension Response {
    func mapResult<T: Decodable>(_ type: T.Type) -> Result<T, Error> {
        do {
            let result = try self.map(T.self)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
