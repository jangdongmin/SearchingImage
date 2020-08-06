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
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var imageCollectionView: ImageCollectionView!
    
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
        imageCollectionView.imageCollectionViewDelegate = self
        
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupBind() {
        self.imageCollectionView.viewModel = viewModel
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .distinctUntilChanged() // 새로운 값이 이전과 같은지 체크
            .filter({ !$0.isEmpty })
            .subscribe(onNext: { query in
                 
                self.searchData(text: query)
                
            })
            .disposed(by: disposeBag)
    }
    
    func searchData(text: String) {
        self.viewModel.searchKeyword(text, 1) { result in
            switch result {
                case .success(let data):
                    if let count = data.documents?.count {
                        if count > 0 {
                            self.emptyLabel.isHidden = true
                        } else {
                            self.emptyLabel.isHidden = false
                        }
                    }
                    
                    self.imageCollectionView.setData(documents: data.documents, meta: data.meta, keyword: text)

                case .failure(let error):
                    print(error)
                    self.emptyLabel.isHidden = false
                    break
            }
        }
    }
    
//    func emptyLabelVisible()
}

extension SearchViewController: ImageCollectionViewDelegate {
    func select(index: Int) {
        
    }
}

