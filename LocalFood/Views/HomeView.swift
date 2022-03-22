//
//  HomeView.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 18.03.2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = HomeViewModel()
    var body: some View {
        ZStack {
            headerSection
            menuSection
            if homeViewModel.noLocation {
                alertSection
            }
        }
        .onAppear {
            // calling location delegate..
            homeViewModel.locationManager.delegate = homeViewModel
        }
        .onChange(of: homeViewModel.search) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if newValue == homeViewModel.search && !homeViewModel.search.isEmpty {
                    homeViewModel.filterData()
                }
            }
            if homeViewModel.search == "" {
                withAnimation(.linear) {
                    homeViewModel.filteredItems = homeViewModel.items
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView {
    
    var header: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.easeInOut) {
                    self.homeViewModel.showMenu.toggle()
                }
                
            } label: {
                Image(systemName: "line.horizontal.3")
                    .font(.title)
                    .foregroundColor(Color("Pink"))
            }
            
            Text(homeViewModel.userLocation == nil ? "Locating..." : "Deliver To")
                .foregroundColor(.black)
                .fontWeight(.bold)
            
            Text(homeViewModel.userAddress)
                .font(.footnote)
                .fontWeight(.heavy)
                .foregroundColor(Color("Pink"))
            
            Spacer(minLength: 0)
            
        }.padding([.horizontal, .top])
        
    }
    var searchBar: some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundColor(.gray)
            TextField("Search", text: $homeViewModel.search)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    func addToCartSection(item: ItemModel) -> some View {
        HStack {
            
            Text("Free Delivery")
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(Color("Pink"))
            
            Spacer(minLength: 0)
            
            Button {
                self.homeViewModel.addToCart(item: item)
            } label: {
                Image(systemName: item.isAddedToCart ? "checkmark" : "plus")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(item.isAddedToCart ? Color.green : Color("Pink"))
                    .clipShape(Circle())
            }
            
        }.padding(.trailing, 10)
            .padding(.top, 10)
    }
    var headerSection: some View {
        VStack(spacing: 10) {
            header
            
            Divider()
            searchBar
            
            Divider()
            if homeViewModel.items.isEmpty {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 25) {
                        ForEach(homeViewModel.filteredItems) { item in
                            ZStack(alignment: .top) {
                                ItemViewRow(item: item)
                                
                                addToCartSection(item: item)
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
    var menuSection: some View {
        HStack {
            MenuView(homeViewModel: homeViewModel)
            
                .offset(x: homeViewModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
            Spacer(minLength: 0)
            
        }
        .background(Color.black.opacity(homeViewModel.showMenu ? 0.3 : 0).ignoresSafeArea().onTapGesture {
            withAnimation(.easeInOut) {
                self.homeViewModel.showMenu.toggle()
            }
        })
    }
    var alertSection: some View {
        Text("Pleaase Enable Location Access in settings to Further move on!")
            .foregroundColor(.accentColor)
            .frame(width: UIScreen.main.bounds.width - 100, height: 120)
            .background(Color.white)
            .cornerRadius(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}
