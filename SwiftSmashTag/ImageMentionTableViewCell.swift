//
//  ImageMentionTableViewCell.swift
//  SwiftSmashTag
//
//  Created by arnaud on 24/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class ImageMentionTableViewCell: UITableViewCell {

    var tweetURL: NSURL? {
        didSet {
            updateUI()
        }

    }
    
    // The width constraint is set up as outlet, so it can be changed
    // the width is changed so that the aspect ratio of the image does not change
    @IBOutlet weak var imageTweetViewWidthConstraint: NSLayoutConstraint!
    
    var tempImage: UIImage? {
        get {
            return imageInTweetView.image
        }
        set {
            // analyse the image and adapt the UIImage-constraints if needed
            // in the storyboard the aspect-ratio is set as constraint
            // this has to be adapted to the aspectratio of the new image
            if let constrainedView = imageInTweetView {
                if let newImage = newValue {
                    self.imageTweetViewWidthConstraint.constant = newImage.aspectRatio * constrainedView.bounds.size.height
                    layoutIfNeeded()
                    imageInTweetView.image = newImage
                } else {
                    self.imageInTweetView.image = nil
                }
            }

        }
    }

    @IBOutlet weak var imageInTweetView: UIImageView!
    
    private func updateUI() {
        imageInTweetView.image = nil
        if let imageURL = tweetURL {
            // do the retrieving off the main thread
            // print(profileImageURL)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                do {
                    // This only works if you add a line to your Info.plist
                    // See http://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http
                    // Add an exception domain for: pbs.twimg.com
                    let imageData = try NSData(contentsOfURL: imageURL, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                    if imageData.length > 0 {
                        // if we have the image data we can go back to the main thread
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if imageURL == self.tweetURL! {
                                // set the received image
                                self.tempImage = UIImage(data: imageData)
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

extension UIImage {
    
    // return the aspectRatio of the image
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}