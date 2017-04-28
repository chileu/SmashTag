//
//  Mention.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/27/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Mention: NSManagedObject {
    
    // twitterInfo = array of Mention that came out of this tweet
    class func findOrCreateMentions(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Mention {
        
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        //should find all mentions where the keyword of the mention matches the search text from the query
        // is this right? or we need to find all mentions that are mentioned in this tweet?
        request.predicate = NSPredicate(format: "keyword = %@", twitterInfo.hashtags)
        
        // see if the mention matches anything in the database, if it does, find out it's count (i.e. times appeared) and increment it. otherwise, create a new mention
        do {
            let matches = try context.fetch(request)

        } catch {           // will catch if there is a database error and we can't fetch
            throw error     // rethrow the error
        }
        
        // create a new mention
        let mention = Mention(context: context)

        //mention.keyword = searchText
        
        return mention
    }
}
