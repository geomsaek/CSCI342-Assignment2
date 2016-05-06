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
    
    var nameList = [String]()
    var hasResults = false
    var filterList = [String]()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    //var clippingSearchResults = [[String]()]
    
    
    override func viewDidLoad() {
        
        searchResults.removeAll()
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        
        // get the name via the passed index
        updateClipData()
        compileNameList()

        super.viewDidLoad()
        self.tableView.reloadData()
        
        
    }
    
    func compileNameList(){

        for i in 0..<clipping.count {
            nameList.append(clipping[i][0])
        }    
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        var tempName : String?
        var found = false;
        
        searchResults.removeAll()
        for i in 0..<clipping.count {
        
            if self.clipping[i][0].lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString){
               searchResults.append(self.clipping[i])
                hasResults = true
            }
        }
        
        self.resultsController.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hasResults {
            
            return self.searchResults.count

        }else {
            return self.clipping.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("clip", forIndexPath: indexPath) as! ClippingCell
        

        let index = indexPath.row
        var file = ""
        
        if hasResults {
            file = collections.fileInDocumentsDirectory(self.searchResults[index][2])
            cell.photo.image = collections.loadImageFromPath(file)
            
            cell.clipTitle!.text = searchResults[index][0]
            cell.clipNotes!.text = searchResults[index][1]
            
        }else {
        
            file = collections.fileInDocumentsDirectory(self.clipping[index][2])
            cell.photo.image = collections.loadImageFromPath(file)
            
            cell.clipTitle!.text = clipping[index][0]
            cell.clipNotes!.text = clipping[index][1]
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var index : Int
        
        // if the segue is to show the selected clipping
        
        if hasResults {

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
            self.clippingListCells.reloadData()
            self.tableView.reloadData()
            searchResults.removeAll()
            hasResults = false
            
        }else {
            if segue.identifier == "ShowClipping" {
                
                index = self.tableView.indexPathForSelectedRow!.row
                setSegueController(segue, selectedIndex: index)
                
            }else {
                
                // selected to allow for a new clipping
                let newClippingView = segue.destinationViewController as! NewClippingView

                //collections = self.collections
                newClippingView.collectionName = self.selectedCollectionName
            }
        }
        
    }
    
    func setSegueController(segue: UIStoryboardSegue, selectedIndex: Int){
        
        var selectedClip : String?
        var selectedNotes : String?
        var selectedDate : String?
        var selectedImg : String?
        
        let clippingDetailController = segue.destinationViewController as! ClippingDetailViewController
        
        selectedClip = clipping[selectedIndex][0]
        selectedNotes = clipping[selectedIndex][1]
        selectedDate = clipping[selectedIndex][3]
        selectedImg = clipping[selectedIndex][2]
        
        clippingDetailController.clippingName = selectedClip
        clippingDetailController.notes = selectedNotes
        clippingDetailController.clippingDte = selectedDate
        clippingDetailController.imgName = selectedImg
        
    }
    
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
