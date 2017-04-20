//
//  ImageViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/20/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.5
            scrollView.maximumZoomScale = 1.5
            scrollView.addSubview(imageView)
        }
    }

    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
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

}
