//
//  FilterViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 20.11.25.
//

import Foundation
import Combine

@MainActor
final class FilterViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var selectedBrands: [String] = []
    @Published var selectedModels: [String: [String]] = [:] // [brand: [models]]
    @Published var selectedGenerations: [String: [String]] = [:] // [model: [generations]]
    @Published var priceRange: ClosedRange<Double> = 0...100_000_000
    @Published var yearRange: ClosedRange<Double> = 1990...2025
    @Published var mileageRange: ClosedRange<Double> = 0...500_000
    @Published var selectedFuelTypes: [String] = []
    @Published var selectedTransmissions: [String] = []
    @Published var selectedBodyTypes: [String] = []
    
    @Published var searchText = ""
    @Published var filteredBrands: [String] = []
    @Published var isLoading = false
    @Published var filteredCarsCount = 0
    
    // MARK: - Private Properties
    private let carService = CarService.shared
    private var allBrands: [String] = Brands.allBrands
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        setupSearchObserver()
        loadInitialData()
    }
    
    // MARK: - Setup
    private func setupSearchObserver() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterBrands(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func loadInitialData() {
        filteredBrands = allBrands
    }
    
    // MARK: - Brand/Model Management
    func filterBrands(searchText: String) {
        if searchText.isEmpty {
            filteredBrands = allBrands
        } else {
            filteredBrands = allBrands.filter { brand in
                brand.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func addBrand(_ brand: String) {
        if !selectedBrands.contains(brand) {
            selectedBrands.append(brand)
        }
    }
    
    func removeBrand(_ brand: String) {
        selectedBrands.removeAll { $0 == brand }
        selectedModels.removeValue(forKey: brand)
        selectedGenerations = selectedGenerations.filter { key, _ in
            !key.contains(brand)
        }
    }
    
    func addModel(_ model: String, for brand: String) {
        if selectedModels[brand] == nil {
            selectedModels[brand] = [model]
        } else if !selectedModels[brand]!.contains(model) {
            selectedModels[brand]!.append(model)
        }
    }
    
    func removeModel(_ model: String, from brand: String) {
        selectedModels[brand]?.removeAll { $0 == model }
        if selectedModels[brand]?.isEmpty == true {
            selectedModels.removeValue(forKey: brand)
        }
        
        // Remove related generations
        let generationKeys = selectedGenerations.keys.filter { $0.contains(model) }
        for key in generationKeys {
            selectedGenerations.removeValue(forKey: key)
        }
    }
    
    // MARK: - Filter Operations
    func applyFilters() async -> [Car] {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let filteredCars = try await carService.searchCars(
                brands: selectedBrands.isEmpty ? nil : selectedBrands
            )
            
            await MainActor.run {
                filteredCarsCount = filteredCars.count
            }
            
            return filteredCars
        } catch {
            print("Error applying filters: \(error)")
            return []
        }
    }
    
    func resetFilters() {
        selectedBrands.removeAll()
        selectedModels.removeAll()
        selectedGenerations.removeAll()
        priceRange = 0...100_000_000
        yearRange = 1990...2025
        mileageRange = 0...500_000
        selectedFuelTypes.removeAll()
        selectedTransmissions.removeAll()
        selectedBodyTypes.removeAll()
        searchText = ""
        filteredBrands = allBrands
        filteredCarsCount = 0
    }
    
    // MARK: - Computed Properties
    var selectedFiltersCount: Int {
        var count = 0
        count += selectedBrands.count
        count += selectedModels.values.flatMap { $0 }.count
        count += selectedGenerations.values.flatMap { $0 }.count
        count += selectedFuelTypes.count
        count += selectedTransmissions.count
        count += selectedBodyTypes.count
        
        if priceRange.lowerBound > 0 || priceRange.upperBound < 100_000_000 { count += 1 }
        if yearRange.lowerBound > 1990 || yearRange.upperBound < 2025 { count += 1 }
        if mileageRange.lowerBound > 0 || mileageRange.upperBound < 500_000 { count += 1 }
        
        return count
    }
    
    var hasActiveFilters: Bool {
        return selectedFiltersCount > 0
    }
}
