//
//  TweetTableViewCell.swift
//  SwiftSmashTag
//
//  Created by arnaud on 21/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    // explanation: http://stackoverflow.com/questions/24666515/how-do-i-make-an-attributed-string-using-swift
    //
    private struct MentionsAttributes {
        static let HashtagAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        static let URLAttributes = [NSForegroundColorAttributeName: UIColor.greenColor()]
        static let UserScreenNameAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenName: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    private func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenName?.text = nil
        tweetProfileImageView?.image = nil
        
        // load new information from our tweet (if any)
        if let currentTweet = self.tweet {
            tweetTextLabel?.text = currentTweet.text
            // create the basic attributed text
            // should I add the default font, etc options here?
            // print(currentTweet.description)
            if tweetTextLabel?.text != nil {
                for _ in currentTweet.media {
                    // add the number of images associated with a tweet
                    tweetTextLabel.text! += "📷"
                }
                // I should highlight urls/hash tags and usernames with a different color
                // these are found in currentTweet.urls, currentTweet.hashtags and currentTweet.user_mentions
                // loop over each IndexKeyword in each mention type
                // create the attributed string, where we will change the attributes where appropriate
                let textWithAttributedMentions = NSMutableAttributedString(string:tweetTextLabel.text!)
                textWithAttributedMentions.addAttributes(MentionsAttributes.HashtagAttributes, indexedKeywords: currentTweet.hashtags)
                textWithAttributedMentions.addAttributes(MentionsAttributes.URLAttributes, indexedKeywords: currentTweet.urls)
                textWithAttributedMentions.addAttributes(MentionsAttributes.UserScreenNameAttributes, indexedKeywords: currentTweet.userMentions)
                                // assign the attributed string to label
                tweetTextLabel!.attributedText = textWithAttributedMentions
            }
            
            tweetScreenName?.text = "\(currentTweet.user)"
            
            if let profileImageURL = currentTweet.user.profileImageURL {
                // do the retrieving off the main thread
                // print(profileImageURL)
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                    do {
                        // This only works if you add a line to your Info.plist
                        // See http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
                        // Add an exception domain for: pbs.twimg.com
                        let imageData = try NSData(contentsOfURL: profileImageURL, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                        if imageData.length > 0 {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                if profileImageURL == self.tweet!.user.profileImageURL {
                                    // if we have the image data we can go back to the main thread
                                    self.tweetProfileImageView?.image = UIImage(data: imageData)
                                }
                            })
                        }
                    }
                    catch {
                        print(error)
                    }
                })
            }
        }
    }
}

// An example of creating elegant code through private extensions
// https://github.com/sanjibahmad/Smashtag/blob/master/Smashtag/TweetTableViewCell.swift
//
private extension NSMutableAttributedString {
    func addAttributes(attrs: [String : AnyObject], indexedKeywords: [Tweet.IndexedKeyword]) {
        for indexedKeyword in indexedKeywords {
            self.addAttributes(attrs, range: indexedKeyword.nsrange)
        }
    }
}
