//
//  UserEndpoint.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/06.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

enum UserEndpoint: APIConfiguration {
    case searchImage(imageSearchRequest: ImageSearchRequest)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
            case .searchImage:
                return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .searchImage:
            return "/v2/search/image"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .searchImage(let imageSearchRequest):
            guard let parameter = try? imageSearchRequest.asDictionary() else {
                print("asDictionary error")
                return nil
            }
            return parameter
      
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try ApiInfo.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue("KakaoAK \(ApiInfo.appKey)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
 
        // Parameters
        if let parameters = parameters {
            if urlRequest.httpMethod == method.rawValue {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            }
        }
        
        return urlRequest
    }
}
