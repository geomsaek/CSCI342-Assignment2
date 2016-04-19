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
        
        print("============== ADD COLLECTION ==============")
        
        // add a collection
        let collection = NSEntityDescription.entityForName("Collection", inManagedObjectContext: context)
        let colItem = Collection(entity: collection!, insertIntoManagedObjectContext: context)
        colItem.name = collectionName
        
        do {
            try context.save()
            print("Added new Collection: \(collectionName)")
        }catch {
            fatalError("Error in saving collection")
        }
        
        print("==========================================")
    }
    
    // create a new clipping
    func addClipping(clippingName: String, clippingNote: String, clippingImage: String){
        
        print("============== ADD CLIPPING ==============")
        
        let clipping = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: context)
        let clipItem = Clipping(entity: clipping!, insertIntoManagedObjectContext: context)
        clipItem.name = clippingName
        clipItem.images = clippingImage
        clipItem.date = NSDate()
        clipItem.notes = clippingNote
        
        do {
            try context.save()
            print("Added new Clipping: \(clippingName)")
        }catch {
            fatalError("Error in saving clipping")
        }
        
        print("==========================================")
    }
    
    
    // delete clipping
    
    func deleteClipping(clippingName: String){
        
        print("============== REMOVE CLIPPING: " + String(clippingName) + " ==============")
    
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
        
        print("==========================================")
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
    
    // print clippings
    
    func displayClippings(){
        
        print("============== DISPLAY CLIPPINGS ==============")
        
        let fReq: NSFetchRequest = NSFetchRequest(entityName: "Clipping")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fReq.sortDescriptors = [sorter]
        
        do {
            result = try self.context.executeFetchRequest(fReq)
        }catch let nserror1 as NSError{
            error = nserror1
            result = nil
            fatalError(String(error))
        }
        
        for resultItem in result!{
            let resClipItem = resultItem as! Clipping
            print("Clipping Name: \(resClipItem.name), Clipping Image: \(resClipItem.images), Clipping Date: \(resClipItem.date)")
            
            // if the clipping has a collection
            if let temp = resClipItem.collections {
                print("Collection Name: \(temp.name)")
            }
        }
        
        print("==========================================")
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
        
        print("============== Add Clipping " + String(clippingName) + " to Collection: " + String(collectionName) + " ==============")
        
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
        
        print("==========================================")
    }
    
}