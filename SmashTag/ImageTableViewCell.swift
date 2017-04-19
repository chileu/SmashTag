//
//  ImageTableViewCell.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/19/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            spinner.startAnimating()
            updateUI()
        }
    }
    
    private func updateUI() {
        if let imageURL = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let loadedImageData = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    if let imageData = loadedImageData {
                        self?.tweetImage?.image = UIImage(data: imageData)
                    }
                    self?.spinner?.stopAnimating()    
                }
            }
        }
    }
}
