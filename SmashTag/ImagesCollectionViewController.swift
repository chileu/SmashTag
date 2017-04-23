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
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

}
