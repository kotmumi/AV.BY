//
//  ServiceContainer.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct ServiceContainer: View {
    let index: Int
    
    var iconCategory = ["chart.bar.xaxis",
                        "bitcoinsign.circle",
                        "percent",
                        "checkmark.square",
                        "list.bullet.rectangle.portrait",
                        "car.rear.hazardsign",
                        "door.garage.open"]
    var nameCategory = ["Оценка стоимости авто",
                        "Финансы кредиты и лизинг",
                        "Рассрочка",
                        "Чек-лист проверки авто",
                        "Каталог модификаций",
                        "Проверка VIN",
                        "Каталог улуг"]
    
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
