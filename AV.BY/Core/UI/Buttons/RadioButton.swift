//
//  RadioButton.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 10.11.25.
//

import SwiftUI

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                if !title.isEmpty {
                    Text(title)
                }
            }
        }
    }
}
