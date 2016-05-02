//
//  ClippingDetailViewController.swift
//  ass2
//
//  Created by Matthew Saliba on 1/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit
import CoreData

class ClippingDetailViewController: UIViewController {

    
    var collections : ScrapbookModel = ScrapbookModel()
    var clippingName : String?
    var notes : String?
    var imgName : String?
    var clippingDte : String?
    
    @IBOutlet var mainTitle: UILabel!
    @IBOutlet var clipMainImg: UIImageView!
    @IBOutlet var clipDate: UILabel!
    @IBOutlet var clipNotes: UILabel!
    
    override func viewDidLoad() {
        self.mainTitle.text = self.clippingName
        self.clipNotes.text = self.notes
        
        var temp = clippingDte?.componentsSeparatedByString(" ")
        var mod = temp![0] + " " + temp![1]
        self.clipDate.text = mod
        
        var file = collections.fileInDocumentsDirectory(imgName!)
        self.clipMainImg.image = collections.loadImageFromPath(file)
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func deleteClipping(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Delete Clipping",
                                      message:  "Are you sure you want to delete this clipping?",
                                      preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: .Default,
                               handler: { (action:UIAlertAction) ->Void in
                               
                               self.collections.deleteClipping(self.clippingName!)
                               self.performSegueWithIdentifier("showColl", sender: self)

        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(ok)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if segue.identifier == "showColl" {
            let collVC = segue.destinationViewController as! CollectionListViewController
        }
    }

}
