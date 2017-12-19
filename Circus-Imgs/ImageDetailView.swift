//
//  ImageDetailView.swift
//  Circus-Imgs
//
//  Created by Rita Tse on 1/10/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ImageDetailView: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var imgFull: UIImageView!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgMap: MKMapView!
    @IBOutlet weak var mapText: UILabel!
    
    //Data
    var photoTitle: String!
    var photoURL: String!
    var photoTags: String!
    var photoLat: String!
    var photoLong: String!
    
    
    override func viewDidLoad() {
        Model.get.convertLongitude(photoLong)
        Model.get.convertLatitude(photoLat)
        self.loadDetails()
        self.loadMap()
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //normal view from imagefeed
    func loadDetails()
    {
        self.imgTitle.text = photoTitle
        let imgURL = URL(string:photoURL)
        
        let data = NSData(contentsOf: (imgURL)!)
        self.imgFull.image = UIImage(data: data as! Data)
        
    }
    
    //Display Map and pinned location
    func loadMap()
    {
        let thisLat = Model.get.lat
        let thisLong = Model.get.long
        
        //condition if coordinates is not 0
        if (thisLat != 0 && thisLong != 0)
        {
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(thisLat, thisLong)
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            
            imgMap.setRegion(region, animated: true)
            
            imgMap.mapType = MKMapType.standard
            
            //Pin annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = photoTitle
            imgMap.addAnnotation(annotation)
            
            mapText.text = "Image Location"
            
        } else {
            
            //display label
            mapText.text = "No Location Recorded"
        }
        
    }
    
}


