//
//  ViewController.swift
//  BDMobile
//
//  Created by Arthur Lamure on 11/03/2020.
//  Copyright © 2020 Arthur Lamure. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sort: Bool?
    
    var items: [Item]!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchBarTxt: String?
    
    var dataManager: CoreDataManager {
        get {
            return CoreDataManager.shared
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.sort = true
        if let items = dataManager.loadItems() {
            self.items = items
            self.tableView.reloadData()
        }
    }
    func changeSort(_ sender: Any) {
        self.sort = !self.sort!
        if let items = dataManager.loadItems(sort: !self.sort!){
            self.items = items
            self.tableView.reloadData()
        }
    }
}


// MARK: -ViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        dataManager.addItemToFavoris(index: indexPath.row, state: !item.isFavorite)
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!

        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isFavorite ? .checkmark : .none

        return cell
    }
}

// MARK: - SearchBarDelegate
extension ViewController: UISearchBarDelegate{
   
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchText == "") {
        if let items = dataManager.loadItems(sort: self.sort!){
        self.items = items
        tableView.reloadData()
      }
    }else if let items = dataManager.loadItems(sort: self.sort!, searchText){
      self.items = items
      tableView.reloadData()
    }
     
  }
}
