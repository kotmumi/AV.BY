//
//  OtherContainer.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct OtherContainer: View {
    let index: Int
    
    var iconCategory = ["sun.min",
                        "globe",
                        "exclamationmark.circle",
                        "list.bullet.rectangle.portrait"]
    var nameCategory = ["Тема приложения",
                        "Язык приложения",
                        "Сообщить о проблеме",
                        "Политика конфиденциальности"]
    
    init(index: Int) {
        self.index = index
    }
    
    var body: some View {
        NavigationLink(destination: CatalogView()) {
            HStack {
                Image(systemName: iconCategory[index])
                    .padding(.leading)
                
                Text(nameCategory[index])
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.blueText)
                Spacer()
                Image(systemName: "chevron.right")
                    .padding()
            }
            .frame(height: 44)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
