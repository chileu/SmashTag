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
        
        //should find all mentions where the keyword of the mention matches the search text from the query
        // is this right? or we need to find all mentions that are mentioned in this tweet?
        
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@ AND query = %@", mentionInfo.keyword, query)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                matches[0].count += 1
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
