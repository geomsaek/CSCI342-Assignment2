//
//  ClippingListViewController.swift
//  ass2
//
//  Created by Matthew Saliba on 25/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var clippingListCells: UITableView!
    
    var selectedClippingIndex : Int?
    var selectedCollectionName : String?
    var clipping = [[String]()]
    
    var searchResults = [[String()]]
    var hasResults = false
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    
    override func viewDidLoad() {
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        
        // get the name via the passed index
        updateClipData()

        super.viewDidLoad()
        self.tableView.reloadData()
        
        
    }
    
    // function to filter clipping list against the search text input
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        searchResults.removeAll()
        for i in 0..<clipping.count {
        
            if self.clipping[i][0].lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString){
               searchResults.append(self.clipping[i])
                hasResults = true
            }
        }
        
        self.resultsController.tableView.reloadData()
    }
    
    /* standard tableView functions */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    /* standard tableView functions */
    // return the count of the search results if there are search results
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hasResults {
            return self.searchResults.count

        }else {
            return self.clipping.count
        }
    }
    
    
    /* standard tableView functions */
    // return the cells of the table view based on if there are search results
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("clip", forIndexPath: indexPath) as! ClippingCell
        

        let index = indexPath.row
        var file = ""
        
        // if there are search results then prepare the cell from the SearchResult Array
        if hasResults {
            file = collections.fileInDocumentsDirectory(self.searchResults[index][2])
            cell.photo.image = collections.loadImageFromPath(file)
            
            cell.clipTitle!.text = searchResults[index][0]
            cell.clipNotes!.text = searchResults[index][1]
            
        }else {
            
            // if there are no searchResults
            // and the searchController/search field is not active
            // if this sentinel is not here you will see all the clippings when the search bar is accessed
            // and any sort of text is entered initially.
            
            if !searchController.active {
                file = collections.fileInDocumentsDirectory(self.clipping[index][2])
                cell.photo.image = collections.loadImageFromPath(file)
            
                cell.clipTitle!.text = clipping[index][0]
                cell.clipNotes!.text = clipping[index][1]
            }
        }
        
        return cell
    }
    
    // method is called when user edits item in table
    // in context when user swipes to delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            let index = indexPath.row
            collections.deleteClipping(self.clipping[index][0])
            self.clipping.removeAtIndex(index)
        }
        self.viewWillAppear(true)
        
    }
    
    
    // segue to the ClipDetailViewController
    // if the user clicks on a search result
    // or a clipping from the collection List
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var index : Int
        var selectedClip : String?
        var selectedNotes : String?
        var selectedDate : String?
        var selectedImg : String?
        
        // if the segue is to show the selected clipping
        
        if hasResults && searchController.active {
            index = self.resultsController.tableView.indexPathForSelectedRow!.row
            
            var selectedClip : String?
            var selectedNotes : String?
            var selectedDate : String?
            var selectedImg : String?
            
            let clippingDetailController = segue.destinationViewController as! ClippingDetailViewController
            
            selectedClip = searchResults[index][0]
            selectedNotes = searchResults[index][1]
            selectedDate = searchResults[index][3]
            selectedImg = searchResults[index][2]
            
            clippingDetailController.clippingName = selectedClip
            clippingDetailController.notes = selectedNotes
            clippingDetailController.clippingDte = selectedDate
            clippingDetailController.imgName = selectedImg
            searchController.active = false
            
            
        }else {
            
            // if the segue has occurred whilst viewing a table cell
            if segue.identifier == "ShowClipping" {
                
                index = self.tableView.indexPathForSelectedRow!.row
                
                let clippingDetailController = segue.destinationViewController as! ClippingDetailViewController
                
                selectedClip = clipping[index][0]
                selectedNotes = clipping[index][1]
                selectedDate = clipping[index][3]
                selectedImg = clipping[index][2]
                
                clippingDetailController.clippingName = selectedClip
                clippingDetailController.notes = selectedNotes
                clippingDetailController.clippingDte = selectedDate
                clippingDetailController.imgName = selectedImg
                
            }else {
                
                // selected to allow for a new clipping
                let newClippingView = segue.destinationViewController as! NewClippingView

                //collections = self.collections
                newClippingView.collectionName = self.selectedCollectionName
            }
        }
        
        // reset all the data for the segue
        updateClipData()
        self.clippingListCells.reloadData()
        self.tableView.reloadData()
        searchResults.removeAll()
        hasResults = false
        
    }
    
    // get the clipping data if there is a collection associated to it
    func updateClipData(){
        
        var temp : Int
        if selectedClippingIndex > 0 {
            temp = selectedClippingIndex!-1
            self.selectedCollectionName = collections.getCollectionNames(temp)
            self.clipping = collections.getClippingNames(self.selectedCollectionName!)
        }else {
            self.selectedCollectionName = "All Clippings"
            self.clipping = collections.displayClippings()
        }
    }
    
    // need to allow for the table cells to be updated
    // every time the tableview appears
    override func viewDidAppear(animated: Bool) {
        clippingListCells.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateClipData()
        clippingListCells.reloadData()
    }

}
