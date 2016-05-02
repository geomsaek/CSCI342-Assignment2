//
//  ScrapbookModel.swift
//  Assignment2
//
//  Created by Matthew Saliba on 17/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ScrapbookModel : NSObject, NSFetchedResultsControllerDelegate {
    
    // managed object context
    let context : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // fetched result controller
    var frc : NSFetchedResultsController = NSFetchedResultsController()
    
    var fReq: NSFetchRequest? = nil
    var error: NSError? = nil
    var result: [AnyObject]?
    
    
    
    // add a new collection
    func addCollection(collectionName: String){
        
        // add a collection
        let collection = NSEntityDescription.entityForName("Collection", inManagedObjectContext: context)
        let colItem = Collection(entity: collection!, insertIntoManagedObjectContext: context)
        colItem.name = collectionName
        
        do {
            try context.save()
        }catch {
            fatalError("Error in saving collection")
        }
    }
    
    // create a new clipping
    func addClipping(clippingName: String, clippingNote: String, clippingImage: String, clippingDate: String){
        
        let clipping = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: context)
        let clipItem = Clipping(entity: clipping!, insertIntoManagedObjectContext: context)
        clipItem.name = clippingName
        clipItem.images = clippingImage
        clipItem.date = NSDate()
        clipItem.notes = clippingNote
        
        do {
            try context.save()
        }catch {
            fatalError("Error in saving clipping")
        }
    }
    
    
    // delete clipping
    
    func deleteClipping(clippingName: String){
    
        let predicate = NSPredicate(format: "name == '\(clippingName)'")
        
        let fetchRequest = NSFetchRequest(entityName: "Clipping")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.context.executeFetchRequest(fetchRequest) as! [Clipping]
            if let entityToDelete = fetchedEntities.first {
                self.context.deleteObject(entityToDelete)
            }
        } catch {
            fatalError("Error in deleting entity")
        }
        
        do {
            try self.context.save()
        } catch {
            fatalError("Error in saving removed entity")
        }
    }
    
    // delete a collection
    func deleteCollection(collectionName: String){
        let predicate = NSPredicate(format: "name == '\(collectionName)'")
        
        let fetchRequest = NSFetchRequest(entityName: "Collection")
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try self.context.executeFetchRequest(fetchRequest) as! [Collection]
            if let entityToDelete = fetchedEntities.first {
                self.context.deleteObject(entityToDelete)
            }
        } catch {
            fatalError("Error in deleting entity")
        }
        
        do {
            try self.context.save()
        } catch {
            fatalError("Error in saving removed entity")
        }

    }
    
    func getCollection() -> AnyObject {
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Collection")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        }catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        return result!
    }
    
    func countCollections()-> Int {
        
        let colRes = self.getCollection()
        
        return colRes.count
    }
    
    func getClipping(collection: String) -> AnyObject {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Collection")
        fReq.predicate = NSPredicate(format:"name CONTAINS '\(collection)' ")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        } catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        var clipList : AnyObject?
        let fetchedCollections = result!
        
        for resultItem in fetchedCollections {
            let collectionItem = resultItem as! Collection
            
            clipList = collectionItem.clippings!
            
            break;
        }
        
        return clipList!
    }
    
    func countClippings(collection: String) -> Int {
        
        let len = self.getClipping(collection)
        return len.count
    
    }
    
    func getCollectionNames(index: Int) -> String {
    
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Collection")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        }catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        var count = 0
        var collectionName = ""
        for res in result! {
            let temp = res as! Collection
            
            if count == index {
                collectionName = res.name
                break
            }
            
            count += 1
        }
        
        return collectionName
        
    }
    
    func getClippingNames(collectionName: String) -> Array<Array <String>> {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Collection")
        fReq.predicate = NSPredicate(format:"name CONTAINS '\(collectionName)' ")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        } catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        var clipList : AnyObject?
        let fetchedCollections = result!
        var clipping = [[String]()]
        var temp : [String]
        
        for resultItem in fetchedCollections {
            let collectionItem = resultItem as! Collection
            
            let clipList = collectionItem.clippings
            
            for clip in clipList! {

                temp = [String]()
                temp.append(clip.name!)
                temp.append(clip.notes!!)
                temp.append(clip.images!!)
                temp.append(String(clip.date!))
                clipping.append(temp)
                temp.removeAll()
            }
        }
        
        clipping.removeAtIndex(0)
        return clipping
    }
    
    // print collections
    
    func displayCollections(){
        
        print("============== DISPLAY COLLECTION ==============")
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Collection")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        }catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        for resultItem in result! {
            let resColItem = resultItem as! Collection
            print("============= Collection Name: \(resColItem.name) =============")
            
            
            print("============= Collection Clippings =============")
            
            let temp = resColItem.clippings!
            
            for clip in temp {
                let tempName = clip.name!
                let tempNote = clip.notes!
                let tempDate = String(clip.date!)
                let tempImage = (clip.images ?? "") as String
                
                print("Name: " + tempName)
                print("Notes: " + tempNote!)
                print("Date: " + tempDate)
                print("Image: " + tempImage)
            }
            
        }
        
        print("==========================================")
    }
    
    // get all clipping names
    
    func displayClippings() -> Array<Array<String>> {
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Clipping")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fReq.sortDescriptors = [sorter]
        
        var clippingNames = [[String()]]
        var tempClip = [String]()
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        }catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        for resultItem in result!{
            let resClipItem = resultItem as! Clipping
            
            tempClip.append(resClipItem.name!)
            tempClip.append(resClipItem.notes!)
            tempClip.append(resClipItem.images!)
            tempClip.append(String(resClipItem.date!))
            
            clippingNames.append(tempClip)
            
            tempClip.removeAll()
        }
        
        clippingNames.removeAtIndex(0)
        return clippingNames
    }
    
    func displayClippingsofCollection(collectionName: String){
    
        print("============== Clippings of Collection: " + String(collectionName) + " ==============")
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Collection")
        fReq.predicate = NSPredicate(format:"name CONTAINS '\(collectionName)' ")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        } catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        let fetchedCollections = result!
        
        for resultItem in fetchedCollections {
            let collectionItem = resultItem as! Collection
            
            let clipList = collectionItem.clippings
            
            for clip in clipList! {
                
                let tempName = clip.name!
                let tempNote = clip.notes!
                let tempDate = String(clip.date!)
                let tempImage = (clip.images ?? "") as String
                
                print("Name: " + tempName)
                print("Notes: " + tempNote!)
                print("Date: " + tempDate)
                print("Image: " + tempImage)
                
            }
        }
        
        print("==========================================")
    }
    
    // add a clipping to a collection
    
    func addClipToCollection(clippingName: String, collectionName: String){
        
        let colPredicate = NSPredicate(format: "name == '\(collectionName)'")
        
        let colFetchRequest = NSFetchRequest(entityName: "Collection")
        colFetchRequest.predicate = colPredicate
        
        let clipPredicate = NSPredicate(format: "name == '\(clippingName)'")
        let clipFetchRequest = NSFetchRequest(entityName: "Clipping")
        clipFetchRequest.predicate = clipPredicate
        
        do {

            let fetchCollection = try self.context.executeFetchRequest(colFetchRequest) as! [Collection]
            
            let fetchClipping = try self.context.executeFetchRequest(clipFetchRequest) as! [Clipping]
            
            for result in fetchCollection {
                let curCollection = result as! Collection
                
                for foundClip in fetchClipping{
                    let newClip = foundClip as! Clipping
                    newClip.collections = curCollection
                }
            }
            
        }catch {
            fatalError("Fetch did not return anything")
        }
        
        do {
            try self.context.save()
        }catch {
            fatalError("Error in saving clipping to collection")
        }
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        return image
        
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
}