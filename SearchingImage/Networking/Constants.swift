//
//  Constants.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/06.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation

struct ApiInfo {
    static let baseURL = "https://dapi.kakao.com"
    static let appKey = "9596ef2e7fa85f56047d803badd8ed86"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
