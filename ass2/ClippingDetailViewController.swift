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
        self.clipDate.text = self.clippingDte
        self.clipMainImg.image = UIImage(named: self.imgName!)
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
}
