//
//  ViewController.swift
//  HomeWork
//
//  Created by 최진문 on 2024/04/12.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var productID: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productTitle: UILabel!
    @IBOutlet var productDescriptions: UILabel!
    @IBOutlet var productImage: UIImageView!
   
    let scrollView = UIScrollView()
    let refreshControl = UIRefreshControl()
    
    @IBAction func refrshButton(_ sender: UIButton) {
        viewControllerFetchData()
    }
    
    @IBAction func saveWishList(_ sender: UIButton) {
        saveData()
        //leadData()
    }
    
    var viewModel = DataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerFetchData()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        view.addSubview(scrollView)
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
            self.viewControllerFetchData()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        viewControllerFetchData()
//    }
    
    func loadImage() {
        if let thumbnailUrlString = self.viewModel.data?.thumbnail, let thumbnailUrl = URL(string: thumbnailUrlString) {
            URLSession.shared.dataTask(with: thumbnailUrl) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.productImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    func viewControllerFetchData() {
        
        let number = 1...100
        let randomProduct = number.randomElement() ?? 0
        
        let url = URL(string: "https://dummyjson.com/products/\(randomProduct)")!
        viewModel.fetchData(from: url) { [weak self] in
            DispatchQueue.main.async {
                
                self?.loadImage()
                
                switch self?.viewModel.state {
                case .loading:
                    break
                case .success:
                    if let productID = self?.viewModel.data?.id {
                        self?.productID.text = "상품 코드: \(String(productID))"
                    }
                    //                    print(self?.productID.text)
                    self?.productTitle.text = self?.viewModel.data?.title
                    if let productPrice = self?.viewModel.data?.price {
                        self?.productPrice.text = "이 상품의 가격은 \(String(productPrice))$ 입니다."
                    }
                    //                    print(self?.productPrice.text)
                    self?.productDescriptions.text = self?.viewModel.data?.description
                    self?.productImage.image = self?.viewModel.data?.thumbnail as? UIImage
                case .error:
                    break
                default:
                    break
                }
            }
        }
    }
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func saveData() {
        guard let context = self.persistentContainer?.viewContext else {return}
        
        let wishProduct = WishList(context: context)
        
        wishProduct.id = Int32(self.viewModel.data?.id ?? 0)
        wishProduct.title = self.viewModel.data?.title
        wishProduct.price = self.viewModel.data!.price
        
        try? context.save()
    }
    
    //
    //    func leadData() {
    //        guard let context = self.persistentContainer?.viewContext else {return}
    //        let request = WishList.fetchRequest()
    //        let product = try? context.fetch(request)
    //
    //        print(product)
    //    }
    //}
}

