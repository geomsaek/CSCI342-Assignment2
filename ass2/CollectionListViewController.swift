//
//  CollectionListViewController.swift
//  ass2
//
//  Created by Matthew Saliba on 19/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit
import CoreData

class CollectionListViewController: UITableViewController,NSFetchedResultsControllerDelegate  {
    
    var collections : ScrapbookModel = ScrapbookModel()
    var userCollectionName : String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addCollection(sender: AnyObject) {
        openCollectionAlert()
    }
    
    func openCollectionAlert(){
    
        let alert = UIAlertController(title: "New Collection",
            message:  "Enter the name of Collection",
            preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "Save",
                               style: .Default,
                               handler: { (action:UIAlertAction) ->Void in
                                let textField = alert.textFields![0] as UITextField
                                
                                self.userCollectionName = String(textField.text!)
                                
                                // add a new collection
                                if let temp = self.userCollectionName {
                                    if temp.characters.count > 0 {
                                        self.collections.addCollection(temp)
                                        self.tableView.reloadData()
                                    }
                                }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in textField.placeholder = "Collection Name" }
        
        alert.addAction(ok)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let colCount = collections.countCollections()
        return colCount + 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        var index = indexPath.row
        var titles : String?
        
        if index > 0 {
            titles = collections.getCollectionNames(index-1)
        }else {
            titles = "All Clippings"
        }
        cell.textLabel!.text = String(titles!)
        
        return cell
    }
    
    // method is called when user edits item in table
    // in context when user swipes to delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            let index = indexPath.row
            var collectName : String
            
            if indexPath.row > 0 {
                collectName = collections.getCollectionNames(index-1)
                collections.deleteCollection(collectName)
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let clippingViewController = segue.destinationViewController as! ClippingListViewController
        clippingViewController.collections = self.collections
        clippingViewController.selectedClippingIndex = self.tableView.indexPathForSelectedRow!.row
        
    }
    
}
