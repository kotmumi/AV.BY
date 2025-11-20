//
//  CategoryView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import SwiftUI

struct Category: Hashable {
    let title: String
    let description: String?
    let icon: String
}

struct CategoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let categories: [Category] = [
        Category(title: "Легковой автомобиль", description: "Более 100 000 пользователей ежедневно смогут увидеть ваше объявление", icon: "secondaryCar"),
        Category(title: "Грузовик или фурго", description: nil,  icon: "trucks"),
        Category(title: "Мототехника", description: nil, icon: "motorcycles"),
        Category(title: "Автобусы и микроавтобусы", description: nil, icon: "buses"),
        Category(title: "Спецтехника", description: nil, icon: "specialMachinery"),
        Category(title: "Сельхозтехника", description: nil, icon: "agriculturalMachinery"),
        Category(title: "Водный транспорт", description: nil, icon: "waterTransport"),
        Category(title: "Прицепы и полуприцепы", description: nil, icon: "trailers")
    ]
    
    private let categoriesSecondary: [Category] = [
        Category(title: "Запчасти и автотовары", description: nil, icon: "spareParts"),
        Category(title: "Шины и диски", description: nil, icon: "tiresWheels")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Text("Выбор раздела")
                        .font(.headline)
                    HStack {
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Закрыть")
                        }
                    }
                    .padding()
                }
                List {
                    Section("Продажа транспорта") {
                        ForEach(categories, id: \.self) { category in
                            CategoryCell(category: category)
                                .listRowInsets(EdgeInsets())
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .padding(.vertical, 4)
                        }
                    }
                    Section("Запчасти, шины и диски") {
                        ForEach(categoriesSecondary, id: \.self) { category in
                            CategoryCell(category: category)
                                .listRowInsets(EdgeInsets())
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .padding(.vertical, 4)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

#Preview {
    CategoryView()
}
