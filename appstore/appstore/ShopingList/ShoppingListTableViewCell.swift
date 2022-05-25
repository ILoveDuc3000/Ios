//
//  ShoppingListTableViewCell.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import SwipeCellKit

class ShoppingListTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func bindData(item: ShoppingList) {
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String
        let currentDateFormater = dateFormatter()
        currentDateFormater.dateFormat = "dd/MM/YYYY"
        
        let date = currentDateFormater.string(from: item.date)
        
        self.nameLabel.text = item.name
        self.totalItemsLabel.text = "\(item.totalItems) Items"
        self.totalPriceLabel.text = "Total \(currency) \(String(format: "%.2f", item.totalPrice))"
        self.dateLabel.text = date
        self.totalPriceLabel.sizeToFit()
        self.nameLabel.sizeToFit()

        
    }


}
