//
//  ImageSearchResponse.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/05.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation

struct ImageSearchResponse: Codable {
    let meta: meta?
    let documents: [documents]?
}

struct meta: Codable {
    let total_count: Int? //    검색된 문서 수
    let pageable_count: Int? //    total_count 중 노출 가능 문서 수
    let is_end: Bool? //    현재 페이지가 마지막 페이지인지 여부, 값이 false면 page를 증가시켜 다음 페이지를 요청할 수 있음
}

struct documents: Codable {
    let collection: String? //    컬렉션
    let thumbnail_url: String? //    미리보기 이미지 URL
    let image_url: String? //    이미지 URL
    let width: Int? //    이미지의 가로 길이
    let height: Int? //    이미지의 세로 길이
    let display_sitename: String? //    출처
    let doc_url: String? //    문서 URL
    let datetime: String? //    문서 작성시간. ISO 8601. [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
}
