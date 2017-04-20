//
//  RecentSearchesTableViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/20/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit

class RecentSearchesTableViewController: UITableViewController {

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination.contentViewController
        if let identifier = segue.identifier,
            identifier == "ShowRecentSearches",
            let destinationVC = destinationVC as? TweetTableViewController {
            if let text = (sender as? UITableViewCell)?.textLabel?.text {
                destinationVC.searchText = text
                RecentSearches.add(text)
            }
        }
    }
}



