//
//  ItemTableViewCell.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantityBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.quantityBackground.layer.cornerRadius = quantityBackground.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func bindData(item: ShoppingItem) {
        
        let currency = userDefaults.value(forKey: kCURRENCY) as! String

        self.nameLabel.text = item.name
        self.extraInfoLabel.text = item.info
        self.quantityLabel.text = "\(item.quantity)"
        self.priceLabel.text = "\(currency) \(String(format: "%.2f", item.price))"
        
        self.priceLabel.sizeToFit()
        self.nameLabel.sizeToFit()
        self.extraInfoLabel.sizeToFit()
        
        if item.image != "" {
            
            imageFromData(pictureData: item.image) { (image) in
                self.itemImage.image = maskRoundedImage(image: image!, radius: Float(image!.size.width/2))
                
            }

        } else {
            var image: UIImage!
            
            if item.isBought {
                image = UIImage(named: "ShoppingCartFull")
            } else {
                image = UIImage(named: "ShoppingCartEmpty")
            }
            self.itemImage.image = maskRoundedImage(image: image, radius: Float(image!.size.width/2))

        }
        
    }

}
