//
//  HistoryTableTableViewController.swift
//  SwiftSmashTag
//
//  Created by arnaud on 29/01/16.
//  Copyright © 2016 Hovering Above. All rights reserved.
//

import UIKit

class HistoryTableTableViewController: UITableViewController {

    private var history = SearchQuery()
    
    private var selectedQuery: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search History"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return history.queries.count
    }

    private struct Storyboard {
        static let CellIdentifier = "History Cell"
        static let SegueIdentifier = "Show Search"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellIdentifier, forIndexPath: indexPath)

        cell.textLabel!.text = history.queries[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedQuery = history.queries[indexPath.row]
        performSegueWithIdentifier(Storyboard.SegueIdentifier, sender: self)
    }    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.SegueIdentifier:
                if let vc = segue.destinationViewController as? TweetTableViewController {
                    if selectedQuery != nil {
                        vc.searchText = selectedQuery
                    }
                }
            default: break
            }
        }
    }
}
