//
//  ImageCollectionViewCell.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/21/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = imageURL {
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let loadedImageData = try? Data(contentsOf: url)
                if let imageData = loadedImageData {
                    DispatchQueue.main.async {
                        self?.tweetImageView.image = UIImage(data: imageData)
                        self?.spinner.stopAnimating()
                    }
                }
            }
        }
    }
}
