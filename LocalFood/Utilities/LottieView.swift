//
//  LottieView.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 26.03.2022.
//

import SwiftUI
import Lottie
struct LottieView: UIViewRepresentable {
    var fileName: String
    var loopMode: LottieLoopMode
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let rootView = UIView(frame: .zero)
        let animationView = AnimationView()
        animationView.animation = Animation.named(fileName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: rootView.widthAnchor)
            ])
        return rootView
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) { }
}
