//
//  TweetTableViewCell.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/17/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description
        
        if let tweetText = tweet?.text {
            let mutableTweetText = NSMutableAttributedString(string: tweetText, attributes: nil)
            
            guard let hashtags = tweet?.hashtags else {
                return
            }
            
            for hash in hashtags {
                mutableTweetText.addAttributes([NSForegroundColorAttributeName: UIColor.purple], range: NSRange(location: hash.nsrange.location, length: hash.keyword.characters.count))
            }
            
            guard let urls = tweet?.urls else {
                return
            }
            
            for url in urls {
                mutableTweetText.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: NSRange(location: url.nsrange.location, length: url.keyword.characters.count))
            }
            
            guard let userMentions = tweet?.userMentions else {
                return
            }
            
            for userMention in userMentions {
                mutableTweetText.addAttributes([NSForegroundColorAttributeName: UIColor.orange], range: NSRange(location: userMention.nsrange.location, length: userMention.keyword.characters.count))
            }
    
            tweetTextLabel?.attributedText = mutableTweetText
        }
        
        if let profileImageURL = tweet?.user.profileImageURL {
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    self?.tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
        } else {
            tweetProfileImageView?.image = nil
        }
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
