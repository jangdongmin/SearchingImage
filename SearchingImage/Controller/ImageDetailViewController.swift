//
//  ImageDetailViewController.swift
//  SearchingImage
//
//  Created by Paul Jang on 2020/08/07.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController, UIScrollViewDelegate {
    var document: documents?
    var imageView = UIImageView()
    
    @IBOutlet weak var scrollview: UIScrollView!

    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        
        guard let imageUrl = document?.image_url else {
            print("document?.image_url == nil")
            return
        }
        
        imageView.removeFromSuperview()
        
        //"https://t1.daumcdn.net/cfile/blog/251CA84D54AFE40722"
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil, options: .highPriority) { (image, error, cacheType, url) in
            
            guard let image = image else {
                print("image == nil")
                return
            }
            
            let width = UIScreen.main.bounds.size.width
            let resizeImage = self.resizeImage(image: image, newWidth: width)
            self.imageView.image = resizeImage
            self.imageView.frame = CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height)
            
            print(resizeImage.size.height)
            if self.scrollview.frame.size.height > resizeImage.size.height {
                let POS_Y = self.scrollview.frame.size.height / 2 - resizeImage.size.height / 2

                var topPadding: CGFloat?
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    topPadding = window?.safeAreaInsets.top
                }
                
                let navibarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
                var cal = POS_Y - navibarHeight - CGFloat(topPadding ?? 0)
                if cal < 0 {
                    cal = 0
                }
                self.imageView.frame.origin.y = cal
            }
            
            self.setImageInfo(offset: self.imageView.frame.origin.y + self.imageView.frame.size.height)
        }
        
        scrollview.addSubview(self.imageView)
    }
    
    func setImageInfo(offset: CGFloat) {
        var offsetY = offset
        if let display_sitename = document?.display_sitename {
            if display_sitename != "" {
                let label = UILabel()
                label.text = "출처 : \(display_sitename)"
                label.sizeToFit()
                let y = offsetY + 20
                label.frame.origin = CGPoint(x: 20, y: y)
                
                offsetY = label.frame.origin.y + label.frame.size.height
                scrollview.addSubview(label)
            }
        }
        
        if let datetime = document?.datetime {
            if datetime != "" {
                let label = UILabel()
                label.text = "작성시간 : \(datetime)"
                label.sizeToFit()
                let y = offsetY + 20
                label.frame.origin = CGPoint(x: 20, y: y)
                
                offsetY = label.frame.origin.y + label.frame.size.height
                scrollview.addSubview(label)
            }
        }
        
        self.scrollview.contentSize = CGSize(width: 0, height: offsetY)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let newHeight = newWidth * image.size.height / image.size.width
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
