//
//  ClippingListViewController.swift
//  ass2
//
//  Created by Matthew Saliba on 25/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController {
    
    @IBOutlet var clippingListCells: UITableView!
    
    var selectedClippingIndex : Int?
    var selectedCollectionName : String?
    var clipping = [[String]()]
    var allClips = [[String]()]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {

        // get the name via the passed index
        updateClipData()

        super.viewDidLoad()
        
        // Setup the Search Controller
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
//        definesPresentationContext = true
//        searchController.dimsBackgroundDuringPresentation = false

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedClippingIndex > 0 {
            return self.clipping.count
        }else {
            return self.allClips.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("clip", forIndexPath: indexPath) as! ClippingCell
        
        let index = indexPath.row
        var file = ""
        
        // select a clipping from a collection
        if selectedClippingIndex > 0 {
            
            file = collections.fileInDocumentsDirectory(self.clipping[index][2])
            cell.photo.image = collections.loadImageFromPath(file)
            
            cell.clipTitle!.text = clipping[index][0]
            cell.clipNotes!.text = clipping[index][1]
        }else {
            // select all clippings
            file = collections.fileInDocumentsDirectory(self.allClips[index][2])
            cell.photo.image = collections.loadImageFromPath(file)
            
            cell.clipTitle!.text = self.allClips[index][0]
            cell.clipNotes!.text = self.allClips[index][1]
        }
        
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        print("ERE")
//        var request = NSFetchRequest(entityName: "Serie")
//        filteredTableData.removeAll(keepCapacity: false)
//        let searchPredicate = NSPredicate(format: "SELF.infos CONTAINS[c] %@", searchController.searchBar.text)
//        let array = (series as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        
//        for item in array
//        {
//            let infoString = item.infos
//            filteredTableData.append(infoString)
//        }
//        
//        self.tableView.reloadData()
    }
    
    // method is called when user edits item in table
    // in context when user swipes to delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            let index = indexPath.row
            
            if self.selectedCollectionName == "All Clippings" {
                collections.deleteClipping(self.allClips[index][0])
                self.allClips.removeAtIndex(index)
                
            }else {
                collections.deleteClipping(self.clipping[index][0])
                self.clipping.removeAtIndex(index)
            }
        }
        self.viewWillAppear(true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // if the segue is to show the selected clipping
        
        if segue.identifier == "ShowClipping" {
            let clippingDetailController = segue.destinationViewController as! ClippingDetailViewController
            
            
            let index = self.tableView.indexPathForSelectedRow!.row
            var selectedClip : String?
            var selectedNotes : String?
            var selectedDate : String?
            var selectedImg : String?
            
            if self.selectedCollectionName == "All Clippings" {
                selectedClip = self.allClips[index][0]
                selectedNotes = self.allClips[index][1]
                selectedDate = self.allClips[index][3]
                selectedImg = self.allClips[index][2]
            }else {
                selectedClip = clipping[index][0]
                selectedNotes = clipping[index][1]
                selectedDate = clipping[index][3]
                selectedImg = clipping[index][2]
            }
            
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
    
    func updateClipData(){
        
        var temp : Int
        if selectedClippingIndex > 0 {
            temp = selectedClippingIndex!-1
            self.selectedCollectionName = collections.getCollectionNames(temp)
            self.clipping = collections.getClippingNames(self.selectedCollectionName!)
        }else {
            self.selectedCollectionName = "All Clippings"
            self.allClips = collections.displayClippings()
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
