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

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenName: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenName?.text = nil
        tweetProfileImageView?.image = nil
        
        // load new information from our tweet (if any)
        if let currentTweet = self.tweet {
            tweetTextLabel?.text = currentTweet.text
            if tweetTextLabel?.text != nil {
                for _ in currentTweet.media {
                    tweetTextLabel.text! += " C"
                }
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
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if profileImageURL == self.tweet!.user.profileImageURL {
                                // if we have the image data we can go back to the main thread
                                self.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        })
                    }
                    catch {
                        print(error)
                    }
                })
            }
        }
    }
}
