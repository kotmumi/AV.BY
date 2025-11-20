//
//  CatalogView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 23.10.25.
//

import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel = CatalogViewModel()
    @State private var showingFilters = false
    
    var body: some View {
        ScrollView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        FilterCell(title: "фото 360°")
                        FilterCell(title: "новые авто")
                        FilterCell(title: "с НДС")
                        FilterCell(title: "снят с учета")
                        
                        Button("Фильтры") {
                            showingFilters = true
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Загрузка...")
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
                
                if let error = viewModel.error {
                    VStack {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Повторить") {
                            viewModel.loadCars()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                if viewModel.cars.isEmpty && !viewModel.isLoading && viewModel.error == nil {
                    VStack(spacing: 16) {
                        Image(systemName: "car")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("Объявления не найдены")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        if !viewModel.searchText.isEmpty {
                            Text("Попробуйте изменить поисковый запрос")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 50)
                }
                
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.cars) { car in
                        CarCell(car: car)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.grayBackground)
        .navigationTitle("\(viewModel.cars.count) объявления")
        .refreshable {
            await viewModel.refreshCars()
        }
        .onAppear {
            viewModel.loadCars()
        }
        .sheet(isPresented: $showingFilters) {
            FilterSecondView(viewModel: viewModel)
        }
    }
}

struct FilterCell: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
#Preview {
    CatalogView()
}
