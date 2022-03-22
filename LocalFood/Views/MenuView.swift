//
//  MenuView.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 18.03.2022.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack {
            cartSection
            
            Spacer()
            HStack {
                Spacer()
                
                Text("version 0.1")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Pink"))
            }
            .padding(10)
            
        }
        .padding([.top, .trailing])
        .frame(width: UIScreen.main.bounds.width / 1.6)
        .background(Color.white.ignoresSafeArea())
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(homeViewModel: HomeViewModel())
            .preferredColorScheme(.light)
    }
}

extension MenuView {
    var cartSection: some View {
        NavigationLink {
            CartView(homeViewModel: homeViewModel)
        } label: {
            HStack(spacing: 15) {
                Image(systemName: "cart")
                    .font(.title)
                    .foregroundColor(Color("Pink"))
                Text("Cart")
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer(minLength: 0)
                
            }
            .padding()
        }

    }
}
