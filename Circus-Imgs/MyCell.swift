//
//  MyCell.swift
//  Circus-Imgs
//
//  Created by Rita Tse on 22/8/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import Foundation
import UIKit

class MyCell: UITableViewCell
{
    @IBOutlet weak var myImage: UIImageView!;
    @IBOutlet weak var labelRight: UILabel!;

    @IBOutlet weak var likeButton: UIButton!;
    @IBOutlet weak var shareButton: UIButton!;
    @IBOutlet weak var commentButton: UIButton!;
    
    var index: Int!;
    
    
    @IBAction func favourite(_ sender: Any) {
        
        var currentPhoto : Photos?
        var pName : String!
        var pUrl : String!
        let flag:Bool! = true
        var currentCard : Card?
        var pLat : String!
        var pLong : String!
        
        //print(Model.get.photosArray.count)
        currentPhoto = Model.get.photosArray[index]
        if let _ = currentPhoto
        {
            pName = currentPhoto!.photoTitle
            pUrl = currentPhoto!.photoURL
            pLat = currentPhoto!.photoLat
            pLong = currentPhoto!.photoLong
        }
        
        //check if the URL already exist in the imageDB
        Model.get.getImageFromCoreData()
        if !Model.get.getURLfromDB().contains(pUrl){
            
            Model.get.saveImage(image_name: pName, image_URL: pUrl, image_lat: pLat, image_long: pLong, is_Like: flag, existing: currentCard)
            likeButton.setImage(UIImage(named: "red_ic_favorite_border"), for: .normal)
            
        }
        
        else {
            
            //showAlert()
            print("The message has been liked")
        }
        print(Model.get.imageDB.count)
   
    }
    
    
    //Display the alert view
    func showAlert()
        
    {
        
        let alertMessage = UIAlertController(title: "Notice", message:
            "The image has been liked!", preferredStyle: UIAlertControllerStyle.alert)
        
        alertMessage.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default,handler: nil))
        
        alertMessage.present(alertMessage, animated: true, completion: nil)
        
    }


}
