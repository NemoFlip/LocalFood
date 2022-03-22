//
//  CartItemView.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 21.03.2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct CartItemView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    var cartItem: CartModel
    var body: some View {
        HStack(spacing: 15) {
            WebImage(url: URL(string: cartItem.item.itemImage))
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .cornerRadius(15)
            VStack(alignment: .leading, spacing: 10) {
                Text(cartItem.item.itemName)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Text(cartItem.item.itemDetails)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                HStack(spacing: 15) {
                    Text(homeViewModel.getPrice(value: Float(truncating: cartItem.item.itemCost)))
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Spacer(minLength: 0)
                    
                    Button {
                        if cartItem.quantity > 1 {
                            homeViewModel.cartItems[homeViewModel.getIndex(item: cartItem.item, isCartIndex: true)].quantity -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(.black)
                        
                    }
                    Text("\(cartItem.quantity)")
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.black.opacity(0.06))
                    Button {
                        homeViewModel.cartItems[homeViewModel.getIndex(item: cartItem.item, isCartIndex: true)].quantity += 1
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .heavy))
                            .foregroundColor(.black)
                        
                    }

                }
            }
        }.padding()
    }
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(homeViewModel: HomeViewModel(), cartItem: CartModel(item: ItemModel(id: "", itemName: "", itemCost: 5, itemDetails: "", itemImage: "", itemRatings: ""), quantity: 5))
    }
}
