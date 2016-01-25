//
//  MentionsTableViewController.swift
//  SwiftSmashTag
//
//  Created by arnaud on 24/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    struct TableSection {
        var section: Int
        var sectionCellIdentifier: String
        var sectionTitle: String
    }
    
    struct StoryboardCellIdentifier {
        static let ImageCell = "Image Cell"
        static let HashtagCell = "Hashtag Cell"
        static let URLCell = "URL Cell"
        static let UserCell = "User Cell"
    }
    
    // this must be setup by the calling ViewController
    var tweet: Tweet? = nil {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if tweet != nil {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if tweet != nil {
            switch section {
                case 0: numberOfRows = tweet!.media.count
                case 1: numberOfRows = tweet!.hashtags.count
                case 2: numberOfRows = tweet!.urls.count
                case 3: numberOfRows = tweet!.userMentions.count
            default: break
            }
        }
        return numberOfRows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardCellIdentifier.ImageCell, forIndexPath: indexPath) as! ImageMentionTableViewCell
                
                cell.tweetURL = tweet!.media[indexPath.row].url
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardCellIdentifier.HashtagCell, forIndexPath: indexPath)
                cell.textLabel!.text = tweet!.hashtags[indexPath.row].keyword
                return cell

            case 2:
                let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardCellIdentifier.URLCell, forIndexPath: indexPath)
                cell.textLabel!.text = tweet!.urls[indexPath.row].keyword
                return cell

            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(StoryboardCellIdentifier.UserCell, forIndexPath: indexPath)
                cell.textLabel!.text = tweet!.userMentions[indexPath.row].keyword
                return cell
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return tweet!.media.count > 0 ? "Images in tweet" : nil
        case 1: return tweet!.hashtags.count > 0 ?"Hashtags in tweet" : nil
        case 2: return tweet!.urls.count > 0 ? "URLs in tweet" : nil
        case 3: return tweet!.userMentions.count > 0 ? "Users in tweet" : nil
        default: return nil
        }
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return CGFloat(200)
        default: return CGFloat(44)
        }

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
