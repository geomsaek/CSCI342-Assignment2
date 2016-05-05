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
    var allClips = [[String]()]
    
    
    var nameList = [String]()
    var filterList = [String]()
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        // get the name via the passed index
        updateClipData()
        compileNameList()

        super.viewDidLoad()
        
    }
    
    func compileNameList(){
        
        if selectedCollectionName == "All Clippings" {
            
            for i in 0..<allClips.count {
                nameList.append(allClips[i][0])
            }
            
        }else {
            
            for i in 0..<clipping.count {
                nameList.append(clipping[i][0])
            }
        }
    
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        var tempName : String?
        
        self.filterList = self.nameList.filter { (name:String) -> Bool in
            if name.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString){
                tempName = name
                
                if self.selectedCollectionName == "All Clippings" {
                    self.allClips.removeAll()
                    self.allClips = collections.getClippingsofCollection(self.selectedCollectionName!, clipping: tempName!)
                }else {
                    self.clipping.removeAll()
                    self.clipping = collections.getClippingsofCollection(self.selectedCollectionName!, clipping: tempName!)
                    print(self.selectedCollectionName)
                }
                
                return true
            }else {
                return false
            }
        }

        
        self.resultsController.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.selectedCollectionName == "All Clippings" {
            return self.allClips.count
        }else {
            return self.clipping.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("clip", forIndexPath: indexPath) as! ClippingCell
        
        let index = indexPath.row
        var file = ""
        
        // select a clipping from a collection
        if self.selectedCollectionName == "All Clippings" {
            // select all clippings
            file = collections.fileInDocumentsDirectory(self.allClips[index][2])
            cell.photo.image = collections.loadImageFromPath(file)
            
            cell.clipTitle!.text = self.allClips[index][0]
            cell.clipNotes!.text = self.allClips[index][1]
        }else {
            
//            file = collections.fileInDocumentsDirectory(self.clipping[index][2])
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
