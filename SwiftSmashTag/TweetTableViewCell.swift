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
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    // blocks the main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
        }
    }
}
