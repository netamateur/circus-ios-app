//
//  SavedImageViewController.swift
//  Circus-Imgs
//
//  Created by MACBOOK on 24/9/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import Foundation
import UIKit

class SavedImageViewController: UITableViewController
{
    
    //var model = Model.get
    
    // MARK: - Prepare data for display
    // Make sure the latest data is displayed when the view is displayed
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Model.get.getImageFromCoreData();
        print("Loading image from core data")
        print(Model.get.imageDB.count)
        
    }
    
    override func  viewDidAppear(_ animated: Bool)
    {
        self.tableView.reloadData()
    }
    
    // Just prior to the view appearing, get the latest copy of movies from the model
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    
    // MARK: - Populate the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Model.get.imageDB.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedImageCell", for: indexPath) as! SavedImageCell
        
        let displayCard = Model.get.getImage(indexPath)
        cell.imgName.text = displayCard.imageName
        
        let imgLink = URL(string: displayCard.imageURL!)
        
        if (imgLink != nil) {
            let data = NSData(contentsOf: (imgLink)!)
            cell.imgSmall.image = UIImage(data: data! as Data)
        }
        //cell.imageView!.image = UIImage(named: displayCard.imageName!)
        //cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    // MARK: - Enable Swipe to Delete
    // System method that enables swipe to delete on a row in a tableview controller.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    // System method that gets called when delete is selected
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        Model.get.deleteImage(indexPath)
        //model.imageDB.remove(at: indexPath.row)
        
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    
    
    // MARK: - Table view system methods
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: -Prepare data to image detail view
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        let detailsVC: FavImgDetailViewController = segue.destination as! FavImgDetailViewController
        
        if segue.identifier == "displaySavedImg"
        {
            if let selectedRowIndexPath = tableView.indexPathForSelectedRow
            {
                let selectedCard = Model.get.imageDB[selectedRowIndexPath.row]
                //let photo = photosArray[selectedRowIndexPath.row]
                detailsVC.photoURL = selectedCard.imageURL
                detailsVC.photoTitle = selectedCard.imageName
                
                if selectedCard.imageLong != nil {
                detailsVC.photoLat = selectedCard.imageLat
                detailsVC.photoLong = selectedCard.imageLong
                }
                    
                else{
                detailsVC.photoLat = "0"
                detailsVC.photoLong = "0"
                    
                }
            }
        }
    }
    
}
