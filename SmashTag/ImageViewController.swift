//
//  ImageViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/20/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
            scrollView.addSubview(imageView)
        }
    }
    
    private var scrollViewDidScrollOrZoom = false
    
    private func autoScale() {
        if scrollViewDidScrollOrZoom {
            return
        } else {
            if let scrollView = scrollView {
                if image != nil {
                    scrollView.zoomScale = min(scrollView.bounds.size.height / image!.size.height,
                                                scrollView.bounds.size.width / image!.size.width)
//                    print("(2)scrollView.bounds.size.width: \(scrollView.bounds.size.width)")
//                    print("(2)scrollView.bounds.size.height: \(scrollView.bounds.size.height)")
//                    print("(2)image!.size.height \(image!.size.height)")
//                    print("(2)image!.size.width \(image!.size.width)")
//                    print("zoom scale: \(scrollView.zoomScale)")
                    
                    scrollView.contentOffset = CGPoint(x: (imageView.frame.size.width - scrollView.frame.size.width) / 2,
                                               y: (imageView.frame.size.height - scrollView.frame.size.height) / 2)
                    
//                    print("imageView.frame.size.width: \(imageView.frame.size.width)")
//                    print("imageView.frame.size.height: \(imageView.frame.size.height)")
//                    print("scrollView.frame.size.width: \(scrollView.frame.size.width)")
//                    print("scrollView.frame.size.height: \(scrollView.frame.size.height)")
//                    print("scrollView.contentOffset: \(scrollView.contentOffset)")
//                    print("----------")
                    
                    scrollViewDidScrollOrZoom = false
                }
            }
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()  // resizes the imageView (receiver) to fit whatever image (or subview) is inside of it
            scrollView?.contentSize = imageView.frame.size
            
//            print("before scrollView?.contentSize: \(scrollView?.contentSize)")
//            print("(1)imageView.frame.size.width: \(imageView.frame.size.width)")
//            print("(1)imageView.frame.size.height: \(imageView.frame.size.height)")
//            print("(1)scrollView.frame.size.width: \(scrollView?.frame.size.width)")
//            print("(1)scrollView.frame.size.height: \(scrollView?.frame.size.height)")
            
            scrollViewDidScrollOrZoom = false
            autoScale()
        }
    }

    var imageURL: URL? {
        didSet {
            image = nil
            // already on screen
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let loadedImageData = try? Data(contentsOf: url)
                if let imageData = loadedImageData, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // not on screen yet
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoScale()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollViewDidScrollOrZoom = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidScrollOrZoom = true
    }

}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
