//
//  WishListTableView.swift
//  HomeWork
//
//  Created by 최진문 on 2024/04/14.
//

import UIKit
import CoreData

class WishListTableView: UIViewController {
    
    @IBOutlet var wishList: UITableView!
    
    var wishListItems:[WishList] = []
    
    override func viewDidLoad() {
        wishList.register(UINib(nibName: WishListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WishListTableViewCell.identifier)
        wishList.dataSource = self
        loadWishList()
    }
    
    func loadWishList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<WishList> = WishList.fetchRequest()
        
        do {
            wishListItems = try context.fetch(request)
            wishList.reloadData()
        } catch {
            print("Fetching failed")
        }
    }
}

extension WishListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier, for: indexPath) as? WishListTableViewCell else {
            return UITableViewCell()
        }
        let item = wishListItems[indexPath.row]
        configure(cell:cell, with: item)
        
        return cell
        
    }
    func configure(cell:WishListTableViewCell, with item: WishList) {
        cell.idCell.text = "[\(String(item.id))]"
        cell.titleCell.text = item.title
        cell.priceCell.text = "\(String(item.price)) $"
    }
}


