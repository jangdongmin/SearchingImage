//
//  SearchViewModel.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/05.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation

import RxSwift
//import Alamofire
//import RxCocoa

class SearchViewModel {
    let disposeBag = DisposeBag()

    func searchKeyword(_ text: String, _ page: Int, completion: @escaping (Result<ImageSearchResponse, Error>) -> Void) {
        let fetchImageCount = 30
        let sortType = "accuracy"
        
        let imageSearchRequest = ImageSearchRequest (query: text, sort: sortType, page: page, size: fetchImageCount)
        let request = UserEndpoint.searchImage(imageSearchRequest: imageSearchRequest)
        
        let obj: Single<NetworkResult<ImageSearchResponse>> = APIService.sharedInstance.requestGeneric(request)
        obj.subscribe { response in
            switch response {
                case let .success(value):
                    switch value {
                        case let .success(result):
                            print("success: ", result)
                            completion(.success(result))
                        case let .error(error):
                            print("Error: ", error)
                            completion(.failure(error))
                    }
                    
                case let .error(error):
                    print("Error: ", error)
                    completion(.failure(error))
            }
        }.disposed(by: self.disposeBag) 
    }
    
}
