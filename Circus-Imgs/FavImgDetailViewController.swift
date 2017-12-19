//
//  FavImgDetailViewController.swift
//  Circus-Imgs
//
//  Created by MACBOOK on 6/10/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FavImgDetailViewController : UIViewController

{
    //UI Outlets //Connect them to stroyboard!!!
    @IBOutlet weak var imgFull: UIImageView!
    @IBOutlet weak var imgTitle: UILabel!
    @IBOutlet weak var imgMap: MKMapView!
    
    //Data
    var photoTitle: String!
    var photoURL: String!
    var photoTags: String!
    var photoLat: String!
    var photoLong: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDetails()
        imgMap.mapType = MKMapType.standard
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadDetails(){
        self.imgTitle.text = photoTitle
        let imgURL = URL(string:photoURL)
        
        
        let data = NSData(contentsOf: (imgURL)!)
        self.imgFull.image = UIImage(data: data as! Data)
        
        
        //needs to set downloaded coordinates...
        //condition if coordinates is 0..
        
        let lat: Double = Double(photoLat)!
        let long: Double = Double(photoLong)!
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        
        imgMap.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = photoTitle
        annotation.subtitle = "subtitle"
        imgMap.addAnnotation(annotation)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


