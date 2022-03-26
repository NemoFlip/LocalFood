//
//  CartView.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 21.03.2022.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    navBarSection
                    
                    cartItemsSection
                    // Bottom
                    
                    cartTotalSection
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
            if homeViewModel.showThanking && !homeViewModel.cartItems.isEmpty {
                LottieBackground(showThanks: $homeViewModel.ordered)
                    .onTapGesture {
                        homeViewModel.showThanking = false
                    }
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(homeViewModel: HomeViewModel())
    }
}
extension CartView {
    var navBarSection: some View {
        HStack(spacing: 20) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(Color("Pink"))
            }
            Text("My cart")
                .font(.title)
                .fontWeight(.heavy)
            Spacer()
        }.padding()
    }
    var cartItemsSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(homeViewModel.cartItems) { cartItem in
                    CartItemView(homeViewModel: homeViewModel, cartItem: cartItem)
                        .contextMenu {
                            Button {
                                
                                let indexInCart = homeViewModel.getIndex(item: cartItem.item, isCartIndex: true)
                                let indexInItems = homeViewModel.getIndex(item: cartItem.item, isCartIndex: false)
                                
                                homeViewModel.cartItems.remove(at: indexInCart)
                                
                                homeViewModel.items[indexInItems].isAddedToCart = false
                                homeViewModel.filteredItems[indexInItems].isAddedToCart = false
                            } label: {
                                Text("Remove")
                            }
                            
                        }
                }
            }
        }
    }
    var cartTotalSection: some View {
        VStack {
            HStack {
                Text("Total")
                    .fontWeight(.heavy)
                    .foregroundColor(.gray)
                Spacer()
                Text(homeViewModel.calculateTotalPrice())
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }.padding([.top, .horizontal])
            Button {
                homeViewModel.updateOrder()
            } label: {
                Text(homeViewModel.ordered ? "Cancel order" : "Check out")
                    .font(.title2)
                    .fontWeight(.heavy)
                
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Color("Pink")
                    )
                    .cornerRadius(15)
            }
        }
        .background(Color.white)
    }
}
