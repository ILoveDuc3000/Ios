//
//  GroceryTableViewCell.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//
import UIKit

class GroceryTableViewCell: ItemTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.quantityLabel.isHidden = true
        self.quantityBackground.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(item: GroceryItem) {
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String

        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.priceLabel.text = "\(currency) \(String(format: "%.2f", item.price))"
        
        self.priceLabel.sizeToFit()
        self.nameLabel.sizeToFit()
        self.extraInfoLabel.sizeToFit()
        
        if item.image != "" {
            
            imageFromData(pictureData: item.image) { (image) in
                self.itemImage.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                
            }
            
        } else {
            let image = UIImage(named: "ShoppingCartEmpty")

            self.itemImage.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
            
        }
        
    }

    
}
