//
//  Model.swift
//  Circus-Imgs
//
//  Created by Samuel Fary on 22/8/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftyJSON

//Rest API KEY Goes here
let apiKey = "c21fa3df81455afb0cd447e13ea34179"


class Model
{
    static var get:Model = Model()
    

    private init()
    {
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    //Get a reference to AppDeLegate
    let appDelegate = UIApplication.shared.delegate as!AppDelegate
    
    //Hold a reference to Managed Context
    let managedContext: NSManagedObjectContext
    
    //Create a collection of object to store in database
    var imageDB = [Card]()
    var commentsDB = [Comment]()
    
    
    //retrieves the image as a 'Image' object and not an 'NSManagedObject'
    func getImage(_ indexPath:IndexPath)->Card
    {
        return imageDB[indexPath.row]
    }
    
    //retrieves comments
    func getComment(_ indexPath:IndexPath)->Comment
    {
        return commentsDB[indexPath.row]
    }
    
    
    //retrieves the URLs of image in core data
    func getURLfromDB() -> [String]
    {
        var urlList = [String]()
        for savedPhoto in imageDB {
            
            urlList.append(savedPhoto.imageURL!)
        }
        
        return urlList
    }
    
    //retrieve card by photoURL
    func getCard(image_url: String)->Card
    {
        var targetCard: Card?
        for card in imageDB {
            if image_url == card.imageURL
            {
                targetCard! = card
            }
        }
        return targetCard!
        
    }
    
    //retrieve comment by card
    func getCommentsbyCard(image_url:String)-> [Comment]{
        var commentList = [Comment]()
        for comment in commentsDB{
            if image_url == comment.card?.imageURL {
                commentList.append(comment)
            }
        }
        
        return commentList
    }
    
    
    
    // MARK : CORE DATA PART --CRUD
    
    // U: tackle updating in core data
    func updateDatabase(){
        do{
            try managedContext.save()
            
        }
        catch let error as NSError{
            print ("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    // D: tackle deleting from core data
    /*delete card*/
    func deleteImage (_ indexPath: IndexPath) {
        let image = imageDB[indexPath.item]
        imageDB.remove(at: indexPath.item)
        managedContext.delete(image)
        updateDatabase()
    }
    
    /*delete comment*/
    func deleteComment (_ indexPath: IndexPath) {
        let comment = commentsDB[indexPath.item]
        commentsDB.remove(at: indexPath.item)
        managedContext.delete(comment)
        updateDatabase()
    }
    
    
    
    // R: tackle retrieving from core data
    func getImageFromCoreData()
    {
        do{
            let fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
            let results = try managedContext.fetch(fetchResult)
            imageDB = results as! [Card]
            
        }
        catch let error as NSError {
            print ("Could not fetch \(error) , \(error.userInfo )")
        }
    }
    
    
    /*retriev comment by card*/
    func fetchComments(card: Card?)
    {
        
        do{
            let fetchResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Comment")
            fetchResult.predicate = NSPredicate(format: "card == %@", card!)
            let results = try managedContext.fetch(fetchResult)
            commentsDB = results as! [Comment]
            
            
        }
        catch let error as NSError {
            print ("Could not fetch \(error) , \(error.userInfo )")
        }
        
    }

    
    // C: create record in core data
    func saveImage(image_name:String, image_URL:String, image_lat:String, image_long:String,is_Like:Bool, existing:Card?)
    {
        //let myEntity = NSEntityDescription.entity(forEntityName: "Card", in: managedContext)!
        
        //if existing is not nill then keep updating the moive
        if let _ = existing
        {
            existing!.imageName = image_name
            existing!.imageURL = image_URL
            existing!.isLike = is_Like
            existing!.imageLat = image_lat
            existing!.imageLong = image_long
        }
            
            //create a new card object and update it with the data pass-in from the View Controler
        else{
            
            let newCard = Card(context: managedContext)
            
            if(image_name == ""){
            
                newCard.imageName = "default"
            }
            else{
                
            newCard.setValue(image_name, forKey: "imageName")
                
            }
            
            newCard.setValue(image_URL, forKey: "imageURL")
            newCard.setValue(is_Like, forKey: "isLike")
            newCard.setValue(image_lat, forKey: "imageLat")
            newCard.setValue(image_long, forKey: "imageLong")
            imageDB.append(newCard)
        
        updateDatabase()
    }
    
}
    
    /*create comment*/
    func saveComment(author_name: String, content: String, nCard: Card?)
    {
        let newComment = Comment(context: managedContext)
        newComment.setValue(author_name, forKey: "author")
        newComment.setValue(content, forKey: "text")
        newComment.card = nCard
        nCard?.addToComment(newComment)
        commentsDB.append(newComment)
        updateDatabase()
    }

    
    

   
    // MARK : REST API Part

    //REST API Call - move to Model
    final let urlString = "https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=\(apiKey)&extras=geo%2C+tags%2C+machine_tags%2C+url_z&format=json&nojsoncallback=1"
    
    //create Photos array from Model
    var photosArray = [Photos]()


    //Retreive JSON data from Flickr, add it to Photos
    func downloadJSON()
    {
        
        let url = URL(string: urlString)
        
        var downloadTask = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 5)
        
        downloadTask.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
            
            let jsonData: JSON? = JSON(data!)
            if (jsonData != nil)
            {
                let photos = jsonData?["photos"].dictionaryValue
                
                for (key, element) in photos!
                {
                    if (key == "photo")
                    {
                        for item in element.arrayValue
                        {
                            let urlStr: String = {
                                if let photoURL = item["url_z"].string {
                                    return photoURL as! String
                                }
                                return "Not Found"
                            }()
                            
                            let titleStr: String = {
                                if let photoTitle = item["title"].string {
                                    return photoTitle as! String
                                }
                                return "Untitled"
                            }()
                            
                            let placeIDStr: String = {
                                if let placeID = item["place_id"].string {
                                    return placeID as! String
                                }
                                return "Not Found"
                            }()
                            
                            let latStr: String = {
                                if let photoLat = item["latitude"].string {
                                    return photoLat as! String
                                }
                                return "0"
                            }()
                            
                            let longStr: String = {
                                if let photoLong = item["longitude"].string {
                                    return photoLong as! String
                                }
                                return "0"
                            }()
                            
                            let tagsStr: String = {
                                if let photoTags = item["tags"].string {
                                    return photoTags as! String
                                }
                                return "Not Found"
                            }()
        
                            //appending to Photos Array
                            self.photosArray.append(Photos(photoURL: urlStr, photoTitle: titleStr, placeID: placeIDStr, photoLat: latStr, photoLong: longStr, photoTags: tagsStr))
                            
                            //append to Tags Array
                            self.allTags.append(tagsStr)
                            self.allTags.append(" ")
                            
                        }
                    }
                }
                
                //sends notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: dataModelDidUpdateNotif), object: nil)
            }
            
        }).resume()
        
    }
    
    // MARK: Converting Coordinates
    //default lat and long
    var lat = 0.0
    var long = 0.0
    
    //convert the cooridnates
    func convertLatitude(_ photoLat:String) -> Double
    {
        // var lat = 0.0
        lat = Double(photoLat)!
        return lat
    }
    
    func convertLongitude(_ photoLong:String) -> Double
    {
        //var long = 0.0
        long = Double(photoLong)!
        return long
    }

    
    // MARK : SEARCH FUNCTION

    //combine all Photo tags to load into Search Table
    var allTags = String()
    
    //user selected search keyword
    var keyword = String()
    
    
    // MARK : LEGACY DUMMY DATA PART
    
    /** data for assignemnt1 **/
    var images: [String] = ["mushroom", "xanaduhouses", "londonolympics"]
    
    var users: [String] = ["user1", "user2", "doge"]
    
    var comments: [String] = ["Comment 1", "Dummy Comment 2", "Hahaha #YOLO"]
    
    var search: [String] = ["#cats", "#yasqueen", "#yesyesnono", "#emotionalclub"]

    
}//END OF CLASS


//Struct for Photo Objects
struct Photos {
    
    let photoURL : String
    let photoTitle : String
    let placeID : String
    let photoLat : String
    let photoLong : String
    let photoTags: String
    
    
    init (photoURL:String, photoTitle:String, placeID:String, photoLat:String, photoLong:String, photoTags:String) {
        self.photoURL = photoURL
        self.photoTitle = photoTitle
        self.placeID = placeID
        self.photoLat = photoLat
        self.photoLong = photoLong
        self.photoTags = photoTags
        
    }
}
