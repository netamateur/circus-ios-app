//
//  SearchTableView.swift
//  Circus-Imgs
//
//  Created by Rita Tse on 22/8/17.
//  Copyright © 2017 s3419529. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating
{
    
    var filteredList: [String]?
    var searchList =  [String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //var searchList = Model.get.search
    
    //delimit tag terms for search, add each words to array
    func delimitTags()
    {
        //get each photoTag string into 1 array and separate to individual words
        let tagsString = Model.get.allTags
        let tagsList = tagsString.components(separatedBy: " ")
        
        for word in tagsList {
            searchList.append(word)
        }
        
    }
    
    
    override func viewDidLoad()
    {
        delimitTags()
        filteredList = searchList
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //tableview updates list with given search inputs
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let searches:[String] = filteredList else {
            return 0
        }
        return searches.count
    }
    
    //determine which card to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searches", for: indexPath)
        
        if let searches:[String] = filteredList {
            
            let search = searches[indexPath.row]
            cell.textLabel!.text = search
            
        }
        return cell
        
    }
    
    //updates table from user's search inputs
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text, !searchText.isEmpty
        {
            filteredList = searchList.filter {
                search in return search.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredList = searchList
        }
        tableView.reloadData()
        
    }
    
    //goes to selected search item
    override func prepare (for segue: UIStoryboardSegue, sender: Any?)
    {
        let resultsVC: ResultsViewController = segue.destination as! ResultsViewController
        
        if segue.identifier == "show" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // get the cell associated with the indexPath selected.
                let cell = self.tableView.cellForRow(at: indexPath)!
                
                let selectedKey = cell.textLabel?.text!
                
                Model.get.keyword = selectedKey!

            }
        }
    }

    
}
