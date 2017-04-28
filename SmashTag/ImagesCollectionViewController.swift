//
//  ImagesCollectionViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/21/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter

class ImagesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var tweetImage: UIImageView!
    lazy var tweets = [Array<Twitter.Tweet>]()
    
    struct TweetMedia: CustomStringConvertible {
        var url: URL
        var aspectRatio: Double
        var description: String {
            return "\(url) -" + " \(aspectRatio)"
        }
    }
    
    private lazy var tweetImages =  [[TweetMedia]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("tweets flatmap: \(tweets.flatMap { $0 }.filter { !$0.media.isEmpty } )")
        
        let tweetData = tweets.flatMap { $0 }
            .filter { !$0.media.isEmpty }
            .map { $0.media.map { TweetMedia.init(url: $0.url, aspectRatio: $0.aspectRatio) } }
            .flatMap { $0 }
        tweetImages.append(tweetData)
        
        setLayout()
        
        //print("tweet images: \(tweetImages)")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tweetImages.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetImages[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetImageCell", for: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            cell.imageURL = tweetImages[indexPath.section][indexPath.item].url
        }
        return cell
    }
    
    private struct FlowLayout {
        
        static let columnCount: CGFloat = 3
        
        static let minimumColumnSpacing: CGFloat = 5
        static let minimumItemSpacing: CGFloat = 5
        static let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    var predefinedWidth: CGFloat {
        return ((collectionView?.bounds.width)!
            - FlowLayout.minimumColumnSpacing * (FlowLayout.columnCount - 1)
            - FlowLayout.sectionInset.right * 2) / FlowLayout.columnCount
    }
    
    var sizePredefined: CGSize {
        return CGSize(width: predefinedWidth, height: predefinedWidth)
    }
    
    func setLayout() {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.minimumLineSpacing = FlowLayout.minimumColumnSpacing
        layoutFlow.minimumInteritemSpacing = FlowLayout.minimumItemSpacing
        layoutFlow.sectionInset = FlowLayout.sectionInset
        layoutFlow.itemSize = sizePredefined
        collectionView?.collectionViewLayout = layoutFlow
    }

}
