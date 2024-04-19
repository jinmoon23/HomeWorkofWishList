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
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    var wishListItems: [WishList] = []
    
    
    override func viewDidLoad() {
        wishList.register(UINib(nibName: WishListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WishListTableViewCell.identifier)
        wishList.dataSource = self
        loadWishList()
        
    }
    
    // CoreData Entity에서 데이터를 받아오는 함수
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
    
    // UI인 cell을 스와이프해서 삭제하고 해당하는 셀의 CoreData도 삭제하는 함수
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // 스와이프한 cell의 Data를 식별하기 위한 코드
            let productToDelete = wishListItems[indexPath.row]
            
            // UI cell을 삭제하는 코드
            wishListItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // 해당하는 cell의 CoreData 데이터를 삭제하는 코드
            guard let context = self.persistentContainer?.viewContext else {return}
            context.delete(productToDelete)
            
            do {
                try context.save()
            } catch {
                print("Error deleting context: \(error.localizedDescription)")
            }
        }
        
    }
    
}

extension WishListTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListItems.count
    }
    // 받아온 데이터를 UI cell과 연결하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier, for: indexPath) as? WishListTableViewCell else {
            return UITableViewCell()
        }
        let item = wishListItems[indexPath.row]
        configure(cell:cell, with: item)
        
        return cell
        
    }
    // 받아온 데이터를 UI 컴포넌트로 표현하는 함수
    func configure(cell:WishListTableViewCell, with item: WishList) {
        cell.idCell.text = "[\(String(item.id))]"
        cell.titleCell.text = item.title
        cell.priceCell.text = "\(String(item.price)) $"
    }
}


