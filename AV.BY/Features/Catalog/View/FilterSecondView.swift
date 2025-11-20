//
//  FilterView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import SwiftUI

struct FilterSecondView: View {
    @ObservedObject var viewModel: CatalogViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Марка") {
                    Picker("Выберите марку", selection: $viewModel.selectedBrand) {
                        Text("Любая").tag(nil as String?)
                        ForEach(viewModel.getUniqueBrands(), id: \.self) { brand in
                            Text(brand).tag(brand as String?)
                        }
                    }
                }
                
                Section("Год выпуска") {
                    Picker("Год от", selection: $viewModel.selectedYear) {
                        Text("Любой").tag(nil as Int?)
                        ForEach(viewModel.getUniqueYears(), id: \.self) { year in
                            Text("\(year)").tag(year as Int?)
                        }
                    }
                }
                
                Section {
                    Button("Применить фильтры") {
                        viewModel.filterCars(
                            brand: viewModel.selectedBrand,
                            minYear: viewModel.selectedYear
                        )
                        dismiss()
                    }
                    
                    Button("Сбросить фильтры", role: .destructive) {
                        viewModel.clearFilters()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Фильтры")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                }
            }
        }
    }
}
