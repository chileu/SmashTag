//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/17/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    override func awakeFromNib() {
        searchText = RecentSearches.searches.first
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    private var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            //print("tweets count: \(tweets.flatMap {$0.count}) ")
        }
    }

    var searchText: String? {
        didSet {
            guard let text = searchText else {
                return
            }
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            RecentSearches.add(text)
        }
    }
    
    private func twitterRequest() -> Twitter.Request? {
        if lastTwitterRequest == nil {
            if let query = searchText, !query.isEmpty {
                return Twitter.Request(search: query, count: 100)
            }
        }
        return lastTwitterRequest?.newer
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let imageButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showImages))
        navigationItem.rightBarButtonItem = imageButton
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        searchForTweets()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc private func showImages() {
        performSegue(withIdentifier: "ShowTweetImages", sender: navigationItem.rightBarButtonItem)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
//        cell.textLabel?.text = tweet.text
//        cell.detailTextLabel?.text = tweet.user.name
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    private var selectedTweet: Twitter.Tweet?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTweet = tweets[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "ShowMentions", sender: selectedTweet)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination
        if let destinationVC = destinationVC.contentViewController as? MentionsTableViewController, let identifier = segue.identifier, identifier == "ShowMentions" {
            destinationVC.tweet = sender as? Twitter.Tweet
        }
        if let destinationVC = destinationVC.contentViewController as? ImagesCollectionViewController, let identifier = segue.identifier, identifier == "ShowTweetImages" {
            destinationVC.tweets = tweets
        }
        
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        
        var firstController = self
        
        if let tabBarController = self as? UITabBarController {
            firstController = tabBarController.viewControllers?[0] ?? self
        }
        
        if let navController = firstController as? UINavigationController {
            return navController.visibleViewController ?? self
        } else {
            return self
        }
    }
}

