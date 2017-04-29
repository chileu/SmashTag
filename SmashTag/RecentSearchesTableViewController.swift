//
//  RecentSearchesTableViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/20/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchesTableViewController: UITableViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearches.searches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearches", for: indexPath)
        cell.textLabel?.text = RecentSearches.searches[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RecentSearches.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination.contentViewController
        if let identifier = segue.identifier {
            
            if identifier == "ShowRecentSearches",
            let destinationVC = destinationVC as? TweetTableViewController {
                if let text = (sender as? UITableViewCell)?.textLabel?.text {
                    destinationVC.searchText = text
                    RecentSearches.add(text)
                }
            }
            
            if identifier == "ShowPopularMentions",
                let destinationVC = destinationVC as? PopularMentionsTableViewController {
                if let text = (sender as? UITableViewCell)?.textLabel?.text {
                    destinationVC.mention = text
                    destinationVC.container = container
                }
            }
        }
    }
}



