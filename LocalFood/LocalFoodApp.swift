//
//  LocalFoodApp.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 18.03.2022.
//

import SwiftUI
import Firebase
@main
struct LocalFoodApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
    }
}
