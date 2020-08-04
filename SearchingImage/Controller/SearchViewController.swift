//
//  SearchViewController.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/04.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "이미지 검색"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupBind()
    }

    func setupUI() {
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupBind() {
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged() // 새로운 값이 이전과 같은지 체크
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { [unowned self] query in
                
                guard let text = self.searchController.searchBar.text else { return }
                
                self.viewModel.searchKeyword(text: text, page: 1).subscribe { event in
                    switch event {
                    case let .success(json):
                        print("JSON: ", json)
                        
                    case let .error(error):
                        print("Error: ", error)
                    }
                }.disposed(by: self.disposeBag)
                
            })
            .disposed(by: disposeBag)
    }
}

