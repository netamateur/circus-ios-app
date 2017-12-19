//
//  ResultsViewController.swift
//  Circus-Imgs
//
//  Created by Rita Tse on 4/10/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var resultImg: UIImageView!
    
    //Data
    var photoTitle: String!
    var photoURL: String!
    var photoTags: String!
    
    var selectedKey: String!
    
    //var keyword: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findImage(keyword: Model.get.keyword)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //find image by keyword
    func findImage(keyword: String)
    {
        for photo in Model.get.photosArray
        {
            if (photo.photoTags.contains(keyword))
            {
                let imgURL = URL(string: photo.photoURL)
                let data = NSData(contentsOf: (imgURL)!)
                self.resultImg.image = UIImage(data: data as! Data)
                
            }

            }
        }
    
    }

    


