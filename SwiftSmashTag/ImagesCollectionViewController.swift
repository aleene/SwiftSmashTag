//
//  ImagesCollectionViewController.swift
//  SwiftSmashTag
//
//  Created by arnaud on 30/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController {

    var tweetsWithImages = [[Tweet]]()

    var selectedImageTweet: Tweet? = nil
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetsWithImages[section].count
    }
    
    struct Storyboard {
        static let CellIdentifier = "Tweet Image Cell"
        static let UnwindSegue = "Unwind To TweetTVC To Show Tweet"
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath) as! TweetImageCollectionViewCell
        
        let currentTweet = tweetsWithImages[indexPath.section][indexPath.row]
        let media = currentTweet.media
        if media.count > 0 {
            let firstMedia = media.first
            cell.tweetURL = firstMedia?.url
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedImageTweet = tweetsWithImages[indexPath.section][indexPath.row]
        performSegueWithIdentifier(Storyboard.UnwindSegue, sender: self)

    }

    
}
