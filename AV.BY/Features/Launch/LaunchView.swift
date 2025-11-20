//
//  LaunchView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//
import SwiftUI

struct LaunchView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isLoaded = false
    
    var body: some View {
        Group {
            if isLoaded {
                MainView() // Ваше основное приложение
            } else {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        // Lottie анимация
                        LottieView(
                            name: "loadingCar",
                            loopMode: .loop,
                            animationSpeed: 1.2
                        )
                        .frame(width: 150, height: 150)
                        
                    }
                }
            }
        }
        .onAppear {
            simulateLoading()
        }
    }
    
    private func simulateLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 1.0 {
                progress += 0.05
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isLoaded = true
                    }
                }
            }
        }
    }
}
