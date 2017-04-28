//
//  SmashTweetTableViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/24/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter
import CoreData

// uses the 'Smash' core data model; is an extension of TweetTVC
// also need to change TweetTVC in attribute inspector to this class
class SmashTweetTableViewController: TweetTableViewController {
    
    // container is the database to use. non-private var.
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("starting database load")
        
        // 'context' below refers to new context that was created to perform background task
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            try? context.save()
            print("done loading database")
            
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        // viewContext below is the main Q's context. can not use the main Q's context off the main thread (as below)
        // need context.perform in order to use the main Q context for printing (i.e. on your safe Q for you)
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
                    print("\(tweetCount) tweets")
                }
                
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter Users")
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
        
        let destinationVC = segue.destination
        
        if let destinationVC = destinationVC.contentViewController as? MentionsTableViewController, let identifier = segue.identifier, identifier == "ShowMentions" {
            destinationVC.tweet = sender as? Twitter.Tweet
        }
        
        if let destinationVC = destinationVC.contentViewController as? ImagesCollectionViewController, let identifier = segue.identifier, identifier == "ShowTweetImages" {
            destinationVC.tweets = tweets
        }
    }
    
}
