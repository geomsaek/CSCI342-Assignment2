//
//  NewClippingView.swift
//  ass2
//
//  Created by Matthew Saliba on 1/05/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class NewClippingView: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate {
    
    var collections : ScrapbookModel = ScrapbookModel()
    var collectionName : String?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var clippingNameField: UITextField!
    @IBOutlet var clippingDate: UIDatePicker!
    
    
    // MARK: UIImagePickerControllerDelegate
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
    }
    
    @IBAction func saveClipping(sender: AnyObject) {
        
        
        
    }


}
