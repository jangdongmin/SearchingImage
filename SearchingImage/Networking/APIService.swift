//
//  APIService.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/04.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

enum NetworkError: Int, Error {
    case badRequest = 400
    case authenticationFailed = 401
    case notFoundException = 404
    case contentLengthError = 413
    case quotaExceeded = 429
    case systemError = 500
    case endpointError = 503
    case timeout = 504
}

enum NetworkResult<C: Codable> {
    case success(C)
    case error(NetworkError)
}

class APIService {
    static let sharedInstance = APIService()
    private init() {}
    
    let appKey = "9596ef2e7fa85f56047d803badd8ed86"
    let url = "https://dapi.kakao.com/v2/search/image"
    
    func requestGeneric<C: Codable>(parameters: Parameters, headers: HTTPHeaders) -> Single<NetworkResult<C>> {
        return Single.create { single in

            let request = AF.request(
                self.url,
                method: .get,
                parameters: parameters,
                headers: headers
            ).responseData { response in
                switch response.result {
                case let .success(jsonData):
                    do {
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("\(utf8Text)")
                        }
                        
                        let returnObject = try JSONDecoder().decode(C.self, from: jsonData)
                        single(.success(.success(returnObject)))
                    } catch let error {
                        single(.error(error))
                    }
                    
                case let .failure(error):
                    if let statusCode = response.response?.statusCode {
                        if let networkError = NetworkError(rawValue: statusCode){
                            single(.success(.error(networkError)))
                        }
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func ImageSearch(parameters: Parameters) -> Single<NetworkResult<ImageSearchResponse>> {
        let headersAuth: HTTPHeaders = [ "Authorization": "KakaoAK \(appKey)"]
        return requestGeneric(parameters: parameters, headers: headersAuth)
    }
}


