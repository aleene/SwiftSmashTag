//
//  TweetImageViewController.swift
//  SwiftSmashTag
//
//  Created by arnaud on 28/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController, UIScrollViewDelegate {
    
    var tweetImage: UIImage? {
        get { return tweetImageView.image }
        set {
            // if an image is known the contentSize can be set
            if newValue != nil {
                tweetImageView.image = newValue
                tweetImageView.sizeToFit()
            }
            updateUI()
        }
    }
    
    private var tweetImageView = UIImageView()
    
    var tweetTitle: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(tweetImageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let currentTitle = tweetTitle {
            title = currentTitle + "'s image"
        }
        updateUI()
    }

    private func updateUI(){
        // define the content size
        scrollView?.contentSize = tweetImageView.frame.size

    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            // What are intelligent zoom scales?
            scrollView.minimumZoomScale = 0.3
            scrollView.maximumZoomScale = 3
        }
    }
    
    override func viewDidLayoutSubviews() {
        // calculating the zoomfactor can only(?) be done here
        // Here the actual bounds of the device are known
        if tweetImage != nil {
            zoomAndCenterImageInScrollView(false)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return tweetImageView
    }
    
    private func zoomAndCenterImageInScrollView(animated: Bool) {
        // zoomAndCenterToContentSize zooms and shifts the contentSize area,
        // such that there is no whitespace left within the bounds and
        // the contentSize will be centered in the bounds are of the scrollView
        
        var scale = CGFloat(1.0) // no zoom
        
        if let image = tweetImage {
            // print("Before scaling image size: \(image.size); bounds size: \(scrollView.bounds.size); frame size: \(scrollView.frame.size)")
            if image.aspectRatio < scrollView.bounds.size.aspectRatio {
            // the width of the image is the determining factor
                scale = CGFloat(scrollView.bounds.size.width/image.size.width)
                // print("Scale content to fit width of bounds: \(scale)")
            } else {
            // the height of the image is the determining factor
                scale = CGFloat(scrollView.bounds.size.height/image.size.height)
                // print("Scale content to fit height of bounds: \(scale)")
            }
            scrollView.setZoomScale(scale, animated: animated)
            // print("After scaling image size: \(image.size); bounds size: \(scrollView.bounds.size); frame size: \(scrollView.frame.size)")
        
            // center the contentSize wrt to the bounds
            scrollView.centerContentInScrollView(animated)
        }
    }
}

private extension UIScrollView {
    
    func centerContentInScrollView(animated: Bool) {
        var x = CGFloat(0)
        var y = CGFloat(0)
        
        // print("Before offset contentSize \(self.contentSize); bounds origin: \(self.bounds.origin); frame origin: \(self.frame.origin)")
        x = (self.contentSize.width - self.bounds.width) / 2
        y = (self.contentSize.height - self.bounds.height) / 2
        // print("Offset width>: \(x,y)")
        
        self.setContentOffset(CGPointMake(x, y), animated: animated)
        // print("After offset contentSize \(self.contentSize); bounds origin: \(self.bounds.origin); frame origin: \(self.frame.origin)")
    }
}

private extension UIImage {
        
    // return the aspectRatio of the image
    // I know it is also an element of the MediaItem
    var aspectRatio: CGFloat {
        return self.size.height != 0 ? self.size.width / self.size.height : 0
    }
}


private extension CGSize {
    
    // return the aspectRatio of the image
    // I know it is also an element of the MediaItem
    var aspectRatio: CGFloat {
        return height != 0 ? width / height : 0
    }
}
