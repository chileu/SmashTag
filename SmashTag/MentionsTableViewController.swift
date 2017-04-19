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
            case .Image(let url, _):
                return String(describing: url)
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
                mentionsArray.append(Mention.init(data: data))
            }
            
            
            if let hashtags = tweet?.hashtags {
                let data = hashtags.map { MentionType.Keyword($0.keyword) }
                mentionsArray.append(Mention.init(data: data))
            }
            
            if let userMentions = tweet?.userMentions {
                let data = userMentions.map { MentionType.Keyword($0.keyword) }
                mentionsArray.append(Mention.init(data: data))
            }
            
            if let urls = tweet?.urls {
                let data = urls.map { MentionType.Keyword($0.keyword) }
                mentionsArray.append(Mention.init(data: data))
            }
            
            print("MENTIONS ARRAY: \(mentionsArray)")
            print("--------------------")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionsArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionsArray[section].data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
