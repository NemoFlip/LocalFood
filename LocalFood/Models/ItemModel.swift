//
//  ItemModel.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 20.03.2022.
//

import Foundation

struct ItemModel: Identifiable {
    var id: String
    var itemName: String
    var itemCost: NSNumber
    var itemDetails: String
    var itemImage: String
    var itemRatings: String
    var isAddedToCart: Bool = false
    
}
