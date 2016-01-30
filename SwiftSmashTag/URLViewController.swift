//
//  URLViewController.swift
//  SwiftSmashTag
//
//  Created by arnaud on 29/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class URLViewController: UIViewController {

    var tweetTitle: String? = nil
    
    var url: NSURL? = nil {
        didSet {
            updateURL()
        }
    }
    
    func updateURL() {
        if let currentUrl = url {
            webView?.loadRequest(NSURLRequest(URL: currentUrl))
        }
    }
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateURL()
    }
}
