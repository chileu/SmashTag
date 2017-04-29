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
    
    class func findOrCreateMentions(query: String, mentionInfo: Twitter.Mention, in context: NSManagedObjectContext) throws -> Mention {
        
        // should we find all mentions where the keyword of the mention matches the search text from the query? - no
        // find all mentions from tweets that were found with a particular search query
        // e.g. searching for #federer might return tweets with #tennis. searching for #nadal might also return #tennis.
        // but clicking on detail disclosure button for #federer only returns #tennis hashtags from #federer, not #nadal
        
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword =[cd] %@ AND query = %@", mentionInfo.keyword, query)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                matches[0].count += 1
                print("mention info keyword: \(mentionInfo.keyword)")
                print("query: \(query)")
                print("matches count incremented: \(matches[0].count)")
                print("------")
                return matches[0]
            }
            
        } catch {           // will catch if there is a database error and we can't fetch
            throw error     // rethrow the error
        }
        
        let mention = Mention(context: context)
        mention.keyword = mentionInfo.keyword.lowercased()
        mention.query = query
        mention.count = 1
        return mention
    }
}
