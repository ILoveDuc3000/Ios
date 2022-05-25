//
//  SwipeTableViewHelpers.swift
//  ShopingList
//
//  Created by CNTT on 4/16/21.
//  Copyright © 2021 fit.tdc. All rights reserved.
//
import Foundation
import UIKit

//MARK: SwipeCell Helper function
enum ActionDescriptor {
    case buy, returnPurchase, trash
    
    func title() -> String? {

        switch self {
        case .buy: return "Buy"
        case .returnPurchase: return "Return"
        case .trash: return "Trash"
            
        }
    }
    
    func image() -> UIImage? {
        
        let name: String
        switch self {
        case .buy: name = "BuyFilled"
        case .returnPurchase: name = "ReturnFilled"
        case .trash: name = "Trash"
        }
        
        return UIImage(named: name)
    }
    
    var color: UIColor {
        switch self {
        case .buy, .returnPurchase : return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    }
}


func createSelectedBackgroundView() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
    return view
}
