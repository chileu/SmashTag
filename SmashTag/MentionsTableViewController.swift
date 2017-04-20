//
//  MentionsTableViewController.swift
//  SmashTag
//
//  Created by Chi-Ying Leung on 4/18/17.
//  Copyright © 2017 Chi-Ying Leung. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    private lazy var mentionsArray = [Mention]()
    
    private struct Mention: CustomStringConvertible {
        var title: String
        var data: [MentionType]
        var description: String {
            return String(describing: data)
        }
    }
    
    private enum MentionType: CustomStringConvertible {
        case Image(URL, Double)         // for images(URL, aspectRatio)
        case Keyword(String)            // for hashtags, userMentions, and urls(keyword)
        
        var description: String {
            switch self {
            case .Keyword(let keyword):
                return keyword
            case .Image(let url, let double):
                return "\(url), \(double)"
            }
        }
    }

    var tweet: Twitter.Tweet? {
        didSet {
            //var mediaArray = [MentionType]()
            //var hashtagsArray = [(MentionType)]()
            //var userMentionsArray = [(MentionType)]()
            //var urlsArray = [(MentionType)]()
            
            if let media = tweet?.media {
                let data = media.map { MentionType.Image($0.url, $0.aspectRatio) }
                mentionsArray.append(Mention.init(title: "Images", data: data))
            }
            
            if let hashtags = tweet?.hashtags {
                let data = hashtags.map { MentionType.Keyword($0.keyword) }
                mentionsArray.append(Mention.init(title: "Hashtags", data: data))
            }
            
            if let userMentions = tweet?.userMentions {
                let data = userMentions.map { MentionType.Keyword($0.keyword) }
                mentionsArray.append(Mention.init(title: "User Mentions", data: data))
            }
            
            if let urls = tweet?.urls {
                let data = urls.map { MentionType.Keyword($0.keyword) }
                mentionsArray.append(Mention.init(title: "Urls", data: data))
            }
            
            print("MENTIONS ARRAY: \(mentionsArray)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //print("bounds width: \(view.bounds.size.width)")
        //print("bounds height: \(view.bounds.size.height)")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionsArray[section].data.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentionsArray[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return view.bounds.size.width / CGFloat(ratio)
        case .Keyword(_):
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentionsArray[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Image", for: indexPath)
            
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageURL = url
            }
            return cell
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mention", for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentionsArray[section].data.isEmpty ? "" : mentionsArray[section].title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let text = (sender as? UITableViewCell)?.textLabel?.text
        
        if let identifier = segue.identifier, identifier == "SearchKeyword" {
            if let destinationVC = segue.destination as? TweetTableViewController,
                let text = text {
                    destinationVC.searchText = text
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let text = (sender as? UITableViewCell)?.textLabel?.text
        if let text = text, identifier == "SearchKeyword", text.hasPrefix("http") {
            open(text)
            return false
        } else {
            return true
        }
    }
    
    func open(_ text: String) {
        if let url = URL(string: text) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    print("Open \(text) \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(text) \(success)")
            }
        }
    }
    
}
