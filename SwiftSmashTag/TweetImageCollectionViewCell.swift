//
//  TweetImageCollectionViewCell.swift
//  SwiftSmashTag
//
//  Created by arnaud on 30/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class TweetImageCollectionViewCell: UICollectionViewCell {

    var tweetURL: NSURL? {
        didSet {
            updateUI()
        }
        
    }

    private var tempImage: UIImage? {
        get {
            return image.image
        }
        set {
            // analyse the image and adapt the UIImage-constraints if needed
            // in the storyboard the aspect-ratio is set as constraint
            // this has to be adapted to the aspectratio of the new image
            if let _ = image {
                if let newImage = newValue {
                    // self.image.constant = newImage.aspectRatio * constrainedView.bounds.size.height
                    layoutIfNeeded()
                    image.image = newImage
                } else {
                    self.image.image = nil
                }
            }
        }
    }

    @IBOutlet weak var image: UIImageView!
    
    private func updateUI() {
        image.image = nil
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

private extension UIImage {
    
    // return the aspectRatio of the image
    // I know it is also an element of the MediaItem
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
