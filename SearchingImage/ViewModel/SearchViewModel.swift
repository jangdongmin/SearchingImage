//
//  SearchViewModel.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/05.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
class SearchViewModel {    
    let allHistorySubject = BehaviorRelay(value: [""])
    let sortHistorySubject = BehaviorRelay(value: [""])
    
//    let requestResult = PublishSubject<[AppInfo]>()
    
    func initialSort(text: String) {
        let historyArr = allHistorySubject.value
        
        var sortArr = [String]()
        for historyText in historyArr {
            if (historyText.lowercased() as NSString).range(of: text.lowercased()).lowerBound == 0 {
                sortArr.append(historyText)
            }
        }
        sortHistorySubject.accept(sortArr)
    }
    
    func loadData() {
        if let array = UserDefaults.standard.array(forKey: "history") as? [String] {
            allHistorySubject.accept(array)
        }
    }
    
    func saveData(text: String) {
        if text == "" {
            return
        }
        if var array = UserDefaults.standard.array(forKey: "history") as? [String] {
            if !array.contains(text) {
                array.insert(text, at: 0)
                UserDefaults.standard.set(array, forKey: "history")
            }
        } else {
            UserDefaults.standard.set([text], forKey: "history")
        }
    }
    
    func searchKeyword(text: String, page: Int) -> Single<NetworkResult<ImageSearchResponse>> {
        let imageSearchRequest = ImageSearchRequest (query: text, sort: "accuracy", page: page, size: 30)
        
        guard let parameter = try? imageSearchRequest.asDictionary() else {
            print("asDictionary error")
            return .error(RxError.unknown)
        }
        
        return APIService.sharedInstance.ImageSearch(parameters: parameter)
    }
}
