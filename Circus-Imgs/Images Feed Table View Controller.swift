//
//  Images Feed Table View Controller.swift
//  Circus-Imgs
//
//  Created by Rita Tse on 21/8/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import UIKit

let dataModelDidUpdateNotif = "dataModelDidUpdateNotif"

class ImagesFeedTableViewController: UITableViewController {
    
    //App Logo on Navigation Bar
    override func viewDidAppear(_ animated: Bool) {
        
        let nav = self.navigationController?.navigationBar
        let imageView = UIImageView(frame: CGRect(x: 0, y:0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "circus")
        imageView.image = image
        
        navigationItem.titleView = imageView
        
    }
    
    //Observers
    func createObeservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: dataModelDidUpdateNotif), object: nil)
    }
    
    
    //Observer Handling
    let loadedData = Notification.Name(rawValue: dataModelDidUpdateNotif)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(30,0,0,0)
        Model.get.downloadJSON()
        createObeservers()
    }
    
    
    //reload table after JSON is downloaded
    func getDataUpdate(){
        
        OperationQueue.main.addOperation(
            {
                //update table here
                self.tableView.reloadData()
        })
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    
    //TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //returns a set of images each load
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Model.get.photosArray.count
    }
    
   //Populate Table Cells with JSON data and CoreData
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! MyCell
        
        let photo = Model.get.photosArray[indexPath.row]
        
        cell.labelRight.text = photo.photoTitle
        cell.index = indexPath.row
        
        let imgLink = URL(string: photo.photoURL)
        
        if (imgLink != nil) {
            let data = NSData(contentsOf: (imgLink)!)
            cell.myImage.image = UIImage(data: data! as Data)
        }
        
        //check if the image has been liked, set button image
        Model.get.getImageFromCoreData()
        
        if Model.get.getURLfromDB().contains(photo.photoURL){
            print(photo.photoTitle)
            cell.likeButton.setImage(UIImage(named: "red_ic_favorite_border"), for: .normal)
            
        } else {
            cell.likeButton.setImage(UIImage(named: "ic_favorite_border"), for: .normal)
        }
        
        return cell
    }
    
    
    //MARK: Prepare data for image detail view
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "open"
        {
            let detailsVC: ImageDetailView = segue.destination as! ImageDetailView
            
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow
            {
                let photo = Model.get.photosArray[selectedRowIndexPath.row]
                detailsVC.photoURL = photo.photoURL
                detailsVC.photoTitle = photo.photoTitle
                detailsVC.photoLat = photo.photoLat
                detailsVC.photoLong = photo.photoLong
            }
        }
        
        
        if segue.identifier == "showComment"
        {
            let photoComments: CommentsViewController = segue.destination as! CommentsViewController
            
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow
            {
                let photo = Model.get.photosArray[selectedRowIndexPath.row]
                print(photo.photoTitle)
                Model.get.getImageFromCoreData()
                //create a new card if photo not saved in core data
                if !Model.get.getURLfromDB().contains(photo.photoURL){
                    
                    //prepare a new card for comments view
                    photoComments.card?.imageName = photo.photoTitle
                    photoComments.card?.imageURL = photo.photoURL
                    photoComments.card?.imageLat = photo.photoLat
                    photoComments.card?.imageLong = photo.photoLong
                    
                    Model.get.saveImage(image_name: (photoComments.card?.imageName)!, image_URL: (photoComments.card?.imageURL)!, image_lat: (photoComments.card?.imageLat)!, image_long: (photoComments.card?.imageLong)!, is_Like: false, existing: photoComments.card!)
                    //print(photoComments.card?.imageName!)
                    
                }
                else {
                    
                    photoComments.card! = Model.get.getCard(image_url: photo.photoURL)
                    //print(photoComments.card?.imageName!)
                }
                Model.get.fetchComments(card: photoComments.card!)
                print("THE NUMBER OF COMMENTS")
                print(Model.get.commentsDB.count)
            }
        }
    }
    
    
}//end of class
    


 
