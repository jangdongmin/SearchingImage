//
//  ImageSearchRequest.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/05.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation

struct ImageSearchRequest: Codable {
    let query: String? //검색을 원하는 질의어
    let sort: String? //결과 문서 정렬 방식, accuracy(정확도순) 또는 recency(최신순), 기본 값 accuracy
    let page: Int? //결과 페이지 번호, 1~50 사이의 값, 기본 값 1
    let size: Int? //한 페이지에 보여질 문서 수, 1~80 사이의 값, 기본 값 80
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
