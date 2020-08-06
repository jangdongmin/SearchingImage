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

enum NetworkResult<C: Codable> {
    case success(C)
    case error(AFError)
}

class APIService {
    static let sharedInstance = APIService()
    private init() {}
 
    func requestGeneric<C: Codable>(_ request: URLRequestConvertible) -> Single<NetworkResult<C>> {
        return Single.create { single in
            
            let result = AF.request(request).responseData { response in
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
                    single(.success(.error(error)))
                }
            }
            
            return Disposables.create {
                result.cancel()
            }
        }
    }
}


