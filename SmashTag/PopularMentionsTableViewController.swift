//
//  PopularMentionsTableViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/26/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import CoreData

class PopularMentionsTableViewController: FetchedResultsTableViewController {
    
    override func viewDidLoad() {
        print("mention: \(mention)")
        print("container: \(container)")
    }
    
    var mention: String? { didSet { updateUI() } } // 'mention' is the text from the row that was selected in Recent Search TVC
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    { didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<Mention>?

    private func updateUI() {
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: false),
                                       NSSortDescriptor(key: "keyword", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))]
            request.predicate = NSPredicate(format: "query = [cd] %@", mention!)
            fetchedResultsController = NSFetchedResultsController<Mention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Popular Mentions Cell", for: indexPath)
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.keyword
            cell.detailTextLabel?.text = String(mention.count)
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
