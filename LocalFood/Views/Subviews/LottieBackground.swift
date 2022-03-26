//
//  LottieBackground.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 26.03.2022.
//

import SwiftUI

struct LottieBackground: View {
    @Binding var showThanks: Bool
    var body: some View {
        GeometryReader {_ in
            VStack {
                LottieView(fileName: "98857-thank-you", loopMode: .playOnce)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }.background(Color.black.opacity(0.25).edgesIgnoringSafeArea(.all))
    }
}

struct LottieBackground_Previews: PreviewProvider {
    static var previews: some View {
        LottieBackground(showThanks: .constant(true))
    }
}
