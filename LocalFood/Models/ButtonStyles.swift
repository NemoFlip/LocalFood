//
//  ButtonStyles.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 18.03.2022.
//

import Foundation
import SwiftUI
struct SearchButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
