//
//  PrimaryButton.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 24.10.25.
//
import SwiftUI

struct PrimaryButton<Destination: View>: View {
    
    var title: String = "Button"
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            Spacer()
            Text("\(title)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding([.top,.bottom],20)
            Spacer()
        }
    }
}
