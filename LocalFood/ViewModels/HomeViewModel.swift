//
//  HomeViewModel.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 18.03.2022.
//

import SwiftUI
import CoreLocation
import Foundation
import Firebase
class HomeViewModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    // Location details
    @Published var userLocation: CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    @Published var showMenu = false
    // Item Data
    @Published var items: [ItemModel] = []
    @Published var filteredItems: [ItemModel] = []
    // Cart Data
    @Published var cartItems: [CartModel] = []
    @Published var ordered = false
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //Checking location access
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("Denied")
            self.noLocation = true
        default:
            print("Unknown")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // reading user location and extract data...
        self.userLocation = locations.last
        self.extractLocation()
        self.login()
    }
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { result, error in
            guard let result = result else {
                return
            }
            print(result)
            var address = ""
            //getting area and locality name
            address += result.first?.name ?? ""
            address += ", \(result.first?.locality ?? "")"
            self.userAddress = address
            
            
        }
    }
    // Anonymous logging For Reading DB
    func login() {
        Auth.auth().signInAnonymously { result, error in
            if let error = error {
                print(error)
                return
            } else {
                print("Successfully signed in.")
                // After login fetching data
                self.fetchItemsData()
            }
        }
    }
    func fetchItemsData() {
        let db = Firestore.firestore()
        db.collection("Items").getDocuments { snapshot, error in
            guard let itemData = snapshot else {
                return
            }
            self.items = itemData.documents.compactMap({ document in
                let id = document.documentID
                if
                    let name = document.get(DataBaseItemsField.itemName) as? String,
                    let cost = document.get(DataBaseItemsField.itemCost) as? NSNumber,
                    let ratings = document.get(DataBaseItemsField.itemRatings) as? String,
                    let image = document.get(DataBaseItemsField.itemImage) as? String,
                    let details = document.get(DataBaseItemsField.itemDetails) as? String {
                    return ItemModel(id: id, itemName: name, itemCost: cost, itemDetails: details, itemImage: image, itemRatings: ratings)
                }
                return nil
            })
            self.filteredItems = self.items
        }
    }
    func addItem(name: String, cost: NSNumber, ratings: String, image: String, details: String) {
        let db = Firestore.firestore()
        let data: [String : Any] = [DataBaseItemsField.itemName : name,
                                   DataBaseItemsField.itemCost : cost,
                                   DataBaseItemsField.itemRatings : ratings,
                                   DataBaseItemsField.itemImage : image,
                                   DataBaseItemsField.itemDetails : details
        ]
        db.collection("Items").addDocument(data: data) { error in
            if let error = error {
                print("Error downloading item: \(error)")
            } else {
                print("Successfully downloaded item!")
            }
        }
    }
    // Search or filter data
    func filterData() {
        withAnimation(.linear) {
            self.filteredItems = self.items.filter({ item in
                item.itemName.lowercased().contains(self.search.lowercased())
            })
        }
    }
    func addToCart(item: ItemModel) {
        self.items[getIndex(item: item, isCartIndex: false)].isAddedToCart = !item.isAddedToCart
        let filterIndex = self.filteredItems.firstIndex { retitem in
            return item.id == retitem.id
        } ?? 0
        self.filteredItems[filterIndex].isAddedToCart = !item.isAddedToCart
        if item.isAddedToCart {
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        // else adding
        self.cartItems.append(CartModel(item: item, quantity: 1))
    }
    func getIndex(item: ItemModel, isCartIndex: Bool) -> Int {
        let index = self.items.firstIndex { returneditem in
            return returneditem.id == item.id
        } ?? 0
        let cartIndex = self.cartItems.firstIndex { returnedItem in
            return returnedItem.item.id == item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    func calculateTotalPrice() -> String {
        var price: Float = 0
        cartItems.forEach { item in
            price += Float(item.quantity) * Float(truncating: item.item.itemCost)
        }
        return getPrice(value: price)
    }
    // Writing order data into firebase
    func updateOrder() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let db = Firestore.firestore()
        if ordered {
            ordered = false
            db.collection("Users").document(currentUser.uid).delete { error in
                if let error = error {
                    print("Error deleting order: \(error)")
                    return
                } else {
                    self.ordered = true
                }
            }
            return
        }
        var data: [[String: Any]] = []
        
        cartItems.forEach { cartItem in
            data.append([
                "item_name": cartItem.item.itemName,
                "item_quantity": cartItem.quantity,
                "item_cost": cartItem.item.itemCost,
                
            ])
        }
        ordered = true
        
        db.collection("Users").document(currentUser.uid).setData([
            "ordered_food": data,
            "total_cost": calculateTotalPrice(),
            "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        ]) { error in
            if let error = error {
                print("Error uploading order: \(error)")
                return
            }
            self.ordered = false
            print("Success")
            return
        }
    }
}
 
