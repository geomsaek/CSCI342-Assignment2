//
//  ViewController.swift
//  ass2
//
//  Created by Matthew Saliba on 18/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var scrapbook : ScrapbookModel
        scrapbook = ScrapbookModel()
        
        // create two Collections A and B
        scrapbook.addCollection("Collection A")
        scrapbook.addCollection("Collection B")
        
        // how do i store the image path???
        
        //let img = UIImage(named: "ubuntu.png")
        //let imgData = UIImagePNGRepresentation(img!)
        
        // Create three Clippings (with note values: “1 foo”, “2 foo” and “3 bar” respectively, use images of your choice)
        scrapbook.addClipping("FooOne", clippingNote: "1 foo", clippingImage: "ubuntu.jpg")
        scrapbook.addClipping("FooTwo", clippingNote: "2 foo", clippingImage: "ubuntu.jpg")
        scrapbook.addClipping("FooThree", clippingNote: "3 foo", clippingImage: "ubuntu.jpg")
        
        // print all the collections
        scrapbook.displayCollections()
        
        // print all the clippings
        scrapbook.displayClippings()
        
        scrapbook.addClipToCollection("FooOne", collectionName: "Collection A")
        scrapbook.addClipToCollection("FooTwo", collectionName: "Collection A")
        // add clipping One to Coll
        
        scrapbook.displayCollections()
        
        scrapbook.displayClippingsofCollection("Collection A")
        scrapbook.deleteClipping("FooOne")
        scrapbook.displayClippingsofCollection("Collection A")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

