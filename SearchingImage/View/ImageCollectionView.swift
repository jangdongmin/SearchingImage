
//
//  ImageCollectionView.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/06.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit
import SDWebImage

protocol ImageCollectionViewDelegate {
    func select(index: Int)
}

class ImageCollectionView: UICollectionView {
    var viewModel: SearchViewModel?
    var documents: [documents]?
    var meta: meta?
    var isLoading = false
    var page = 1
    var keyword: String?
    var imageCollectionViewDelegate: ImageCollectionViewDelegate?
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func setData(documents: [documents]?, meta: meta?, keyword: String) {
        self.documents = documents
        self.meta = meta
        self.keyword = keyword
        self.page = 1
        self.isLoading = false
        self.reloadData()
    }
}

extension ImageCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageCollectionViewDelegate?.select(index: indexPath.row)
    }
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = documents?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.frame.size.width / 3 - 2, height: self.frame.size.width / 3 - 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCollectionViewCell.self), for: indexPath) as? ImageCollectionViewCell {
             
            if let thumbnail_url = documents?[indexPath.row].thumbnail_url {
                cell.contentImage.sd_setImage(with: URL(string: thumbnail_url))
            }

            return cell
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let keyword = keyword else {
            print("keyword == nil")
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > self.contentSize.height / 4 && !isLoading && !(meta?.is_end ?? true) {
            isLoading = true
            page += 1
            
            viewModel?.searchKeyword(keyword, page) { result in
                self.isLoading = false
                
                switch result {
                    case .success(let data):
                        guard let documents = data.documents else { return }
                        
                        if var arr = self.documents {
                            arr += documents
                            self.documents = arr
                            
                            self.meta = data.meta
                        } else {
                            self.documents = data.documents
                            self.meta = data.meta
                        }
                        self.reloadData()
                    case .failure(let error):
                        print(error)
                        break
                }
            }
        }
    }
}
