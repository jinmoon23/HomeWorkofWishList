//
//  WishListTableViewCell.swift
//  HomeWork
//
//  Created by 최진문 on 2024/04/14.
//

import UIKit

class WishListTableViewCell: UITableViewCell {

    static let identifier = "WishListTableViewCell"
    
    @IBOutlet var idCell: UILabel!
    @IBOutlet var titleCell: UILabel!
    @IBOutlet var priceCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
