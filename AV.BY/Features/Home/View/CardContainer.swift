//
//  CardContainer.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct CardContainer: View {
    let index: Int
    
    var iconCar = ["secondaryCar", "newCar", "tiresWheels", "trucks", "buses", "motorcycles", "specialMachinery", "agriculturalMachinery", "trailers", "waterTransport", "tiresWheels", "automotiveProducts"]
    var nameCar = ["Авто с пробегом", "Новый авто", "Запчасти", "Грузовики", "Автобусы", "Мототехника", "Спецтехника", "Сельхозтехника", "Прицепы", "Водный транспорт", "Шины и диски", "Автотовары"]
    
    var body: some View {
        NavigationLink(destination: CatalogView()) {
            VStack {
                VStack(alignment: .leading, spacing: 4) {
                    Image(iconCar[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 50)
                }
                .padding(4)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                Text(nameCar[index])
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.black)
            }
        }
    }
}
