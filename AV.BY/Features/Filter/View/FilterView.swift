//
//  FilterView.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 23.10.25.
//

import SwiftUI

struct FilterView: View {
    @StateObject var viewModel: FilterViewModel //= FilterViewModel()
    @State private var count: Int = 1
    @State private var isShowingBrand = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                mainContent
                showResultsButton
            }
            .background(Color.grayBackground)
        }
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack {
            headerView
            brandsListView
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Button("Сбросить") {
                viewModel.resetFilters()
            }
            Spacer()
            Text("Параметры")
            Spacer()
            Button("Закрыть") {
                dismiss()
            }
        }
        .padding()
    }
    
    // MARK: - Brands List
    private var brandsListView: some View {
        ScrollView {
            VStack {
                ForEach(0..<count, id: \.self) { index in
                    brandButton(for: index)
                }
                addMoreButton
            }
        }
    }
    
    // MARK: - Brand Button
    private func brandButton(for index: Int) -> some View {
        Button(action: {
            isShowingBrand = true
        }) {
            HStack {
                brandText(for: index)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
        .padding([.top, .leading, .trailing])
        .sheet(isPresented: $isShowingBrand) {
            BrandView(viewModel: viewModel)
        }
    }
    
    // MARK: - Brand Text
    private func brandText(for index: Int) -> some View {
        Group {
            if index < viewModel.selectedBrands.count {
                Text(viewModel.selectedBrands[index])
                    .foregroundStyle(Color.primary)
            } else {
                Text("Марка, модель, поколение")
                    .foregroundStyle(Color.gray)
            }
        }
    }
    
    // MARK: - Add More Button
    private var addMoreButton: some View {
        Group {
            if count < 10 {
                Button(action: {
                    count += 1
                }) {
                    HStack {
                        Spacer()
                        Text("Еще модель +")
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.grayLogo)
                    .cornerRadius(12)
                }
                .padding([.top, .leading, .trailing])
            }
        }
    }
    
    // MARK: - Show Results Button
    private var showResultsButton: some View {
        Button(action: {
            // Apply filters action
        }) {
            HStack {
                Spacer()
                Text("Показать \(count) объявлений")
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .padding()
            .background(Color.greenButton)
            .cornerRadius(12)
        }
        .padding()
    }
}

#Preview {
    FilterView(viewModel: FilterViewModel())
}
