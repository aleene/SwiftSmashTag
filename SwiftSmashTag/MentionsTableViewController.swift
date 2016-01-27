//
//  MentionsTableViewController.swift
//  SwiftSmashTag
//
//  Created by arnaud on 24/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    private enum MentionType {
        case Media(NSURL)
        case Hashtag(String)
        case URL(String)
        case UserMention(String)
        
        var description: String {
            switch self {
            case .Media(let mediaItem):
                return mediaItem.absoluteString
            case .Hashtag(let hashtag):
                return hashtag
            case .URL(let url):
                return url
            case .UserMention(let userMention):
                return userMention
            }
        }

    }
    
    private struct TableSection {
        var cellIdentifier: String
        var title: String
        var rowHeight: CGFloat
        var mention: [MentionType]
    }
    
    private struct TweetMention {
        var sections: [TableSection] = []
        
        init(withTweet tweet: Tweet?) {
            if let newTweet = tweet {
                // look at each possible section
                if newTweet.media.count > 0 {
                    var mediaMentions: [MentionType] = []
                    for element in newTweet.media {
                        mediaMentions.append(MentionType.Media(element.url))
                    }
                    sections.append(TableSection.init(
                        cellIdentifier: "Image Cell",
                        title: "Images in tweet",
                        rowHeight: 200,
                        mention: mediaMentions))
                }
                if newTweet.hashtags.count > 0 {
                    var hashtagMentions: [MentionType] = []
                    for element in newTweet.hashtags {
                        hashtagMentions.append(MentionType.Hashtag(element.keyword))
                    }
                    sections.append(TableSection.init(
                        cellIdentifier: "Hashtag Cell",
                        title: "Hashtags in tweet",
                        rowHeight: 44,
                        mention: hashtagMentions))
                }
                if newTweet.urls.count > 0 {
                    var urlMentions: [MentionType] = []
                    for element in newTweet.urls {
                        urlMentions.append(MentionType.URL(element.keyword))
                    }
                    sections.append(TableSection.init(
                        cellIdentifier: "URL Cell",
                        title: "URLs in tweet",
                        rowHeight: 44,
                        mention: urlMentions))
                }
                if newTweet.userMentions.count > 0 {
                    var userMentions: [MentionType] = []
                    for element in newTweet.userMentions {
                        userMentions.append(MentionType.UserMention(element.keyword))
                    }
                    sections.append(TableSection.init(
                        cellIdentifier: "User Cell",
                        title: "Users in tweet",
                        rowHeight: 44,
                        mention: userMentions))
                }
            } else {
              sections = []
            }
        }
    }
    
    private var currentTweetMention: TweetMention?
    
    // this must be setup by the calling ViewController
    var tweet: Tweet? = nil {
        didSet {
            // now we know the tweet, we can setup the sections
            self.currentTweetMention = TweetMention(withTweet: tweet)
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
        if let currentTweet = tweet {
            title = currentTweet.user.name
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentTweetMention != nil ? currentTweetMention!.sections.count : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTweetMention != nil ? currentTweetMention!.sections[section].mention.count : 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mention = currentTweetMention!.sections[indexPath.section].mention[indexPath.row]
        switch mention {
            case .Media(let mediaItem):
                let cell = tableView.dequeueReusableCellWithIdentifier(currentTweetMention!.sections[indexPath.section].cellIdentifier, forIndexPath: indexPath) as! ImageMentionTableViewCell
                cell.tweetURL = mediaItem
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(currentTweetMention!.sections[indexPath.section].cellIdentifier, forIndexPath: indexPath)
                cell.textLabel!.text = mention.description
                return cell
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentTweetMention != nil ? currentTweetMention!.sections[section].title : nil
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return currentTweetMention != nil ? currentTweetMention!.sections[indexPath.section].rowHeight : CGFloat(0)
        }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mention = currentTweetMention!.sections[indexPath.section].mention[indexPath.row]
        switch mention {
            case .Media:
                print ("media")
            case .URL(let urlAsString):
                if let url = NSURL(string: urlAsString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            case .Hashtag(let hashtag):
                // should segue back and do a new search with that hashtag
                print("Hashtag: \(hashtag)")
            case .UserMention(let userMention):
                print("Hashtag: \(userMention)")
            
        }
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


