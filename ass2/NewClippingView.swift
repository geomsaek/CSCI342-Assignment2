//
//  NewClippingView.swift
//  ass2
//
//  Created by Matthew Saliba on 1/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit


class NewClippingView: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var clippingNameField: UITextField!
    @IBOutlet var clippingDate: UIDatePicker!
    @IBOutlet var clippingNotes: UITextView!
    
    var collections : ScrapbookModel = ScrapbookModel()
    var collectionName : String?
    var fileName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectImageFromPhoto(sender: UITapGestureRecognizer) {
        
        clippingNameField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage

        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        
        // construct an image name from a random character string
        var temp = randomStringWithLength (10)
        self.fileName = String(temp)
        self.fileName = self.fileName + ".png"
        
    }

    @IBAction func saveClipping(sender: AnyObject) {
        
        let tempName : String = self.clippingNameField.text!
        let tempDate : String = String(self.clippingDate)
        let tempNotes : String = self.clippingNotes.text
        
        self.collections.addClipping(tempName, clippingNote: tempNotes, clippingImage: self.fileName, clippingDate: tempDate)
        
        if collectionName != "All Clippings" {
            
            self.collections.addClipToCollection(tempName, collectionName: collectionName!)
        }
        openSaveAlert()
        
    }
    
    func openSaveAlert(){

        let alert = UIAlertController(title: "Clipping Saved",
                                      message:  "New Clipping Added",
                                      preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK",
                               style: .Default,
                               handler: { (action:UIAlertAction) ->Void in
                                
                                if let navController = self.navigationController {
                                    navController.popViewControllerAnimated(true)
                                }
                                
                                let imagePath = self.collections.fileInDocumentsDirectory(self.fileName)
                                
                                if let image = self.photoImageView.image {
                                    self.collections.saveImage(image, path: imagePath)
                                } else { print("some error message") }
                                
        })
        
        
        
        alert.addAction(ok)

        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

}
