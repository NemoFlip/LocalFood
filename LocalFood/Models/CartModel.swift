
//
//  CartModel.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 21.03.2022.
//

import Foundation

struct CartModel: Identifiable {
    var id = UUID().uuidString
    var item: ItemModel
    var quantity: Int
    
}
