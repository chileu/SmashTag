//
//  Tweet.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/24/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(keyword: String, matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        // see if the tweet matches anything in the database, if it does, just return it and don't create a new one
        do {
            let matches = try context.fetch(request)
            if matches.count > 0  {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {           // will catch if there is a database error and we can't fetch
            throw error     // rethrow the error
        }
        
        // create a new tweet
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        tweet.tweeter = try? TwitterUser.findOrCreateTwitterUser(matching: twitterInfo.user, in: context)
        return addMentions(keyword: "", tweet: tweet, twitterInfo: twitterInfo, in: context)
    }
    
    class func addMentions(keyword: String, tweet: Tweet, twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) -> Tweet {
        let tweetMentions = ["hashtags": twitterInfo.hashtags,
                             "userMentions": twitterInfo.userMentions]
        for (_, mentions) in tweetMentions {
            for mentionInfo in mentions {
                if let mention = try? Mention.findOrCreateMentions(query: keyword, mentionInfo: mentionInfo, in: context) {
                    let mentions = tweet.mutableSetValue(forKey: "mentions")  // mentions is a NSMutableSet
                    mentions.add(mention)   // add this mention to the set of mentions associated with this tweet
                }
            }
        }
        return tweet
    }
}
