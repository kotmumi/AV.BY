//
//  CatalogViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation
import Combine

@MainActor
final class CatalogViewModel: ObservableObject {
    
    @Published var cars: [Car] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText = ""
    @Published var selectedBrand: String?
    @Published var selectedYear: Int?
    
    @Published var filterViewModel = FilterViewModel()
    
    private let carService = CarService.shared
    private let favoritesService = FavoritesService.shared
    private let authManager = AuthManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchObserver()
        setupAuthObserver()
    }
    
    private func setupAuthObserver() {
        authManager.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { isLoggedIn in
                if isLoggedIn {
                   
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupSearchObserver() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if searchText.isEmpty {
                    self?.loadCars()
                } else {
                    self?.searchCars(text: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Car Operations
    func loadCars() {
        isLoading = true
        error = nil
        
        Task {
            do {
                cars = try await carService.fetchCars(limit: 20)
            } catch {
                self.error = "Ошибка загрузки автомобилей"
                print("Error loading cars: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func searchCars(text: String) {
        isLoading = true
        
        Task {
            do {
                let carsByBrand = try await carService.searchCars(brand: text)
                let carsByModel = try await carService.searchCars(model: text)
                
                let allCars = (carsByBrand + carsByModel).reduce(into: [Car]()) { result, car in
                    if !result.contains(where: { $0.id == car.id }) {
                        result.append(car)
                    }
                }
                
                cars = allCars
            } catch {
                self.error = "Ошибка поиска"
            }
            
            isLoading = false
        }
    }
    
    func filterCars(brand: String? = nil, minYear: Int? = nil, maxYear: Int? = nil) {
        isLoading = true
        
        Task {
            do {
                let filteredCars = try await carService.searchCars(
                    brand: brand,
                    minYear: minYear,
                    maxYear: maxYear
                )
                cars = filteredCars
            } catch {
                self.error = "Ошибка фильтрации"
                print("Filter error: \(error)")
            }
            
            isLoading = false
        }
    }
    
    // MARK: - Favorites Operations
    func toggleFavorite(carId: String) {
        guard let userId = authManager.currentUser?.uid else {
            error = "Для добавления в избранное авторизируйтесь"
            return
        }
        
        Task {
            do {
                let isFavorite = try await favoritesService.isCarInFavorites(carId: carId, userId: userId)
                
                if isFavorite {
                    try await favoritesService.removeFromFavorites(carId: carId, userId: userId)
                } else {
                    try await favoritesService.addToFavorites(carId: carId, userId: userId)
                    print("carId:\(carId) userId: \(userId)")
                }
                
                await MainActor.run {
                    objectWillChange.send()
                }
                
            } catch {
                await MainActor.run {
                    self.error = "Ошибка обновления избранного"
                }
            }
        }
    }
    
    func isCarFavorite(carId: String) async -> Bool {
       
            guard let userId = authManager.currentUser?.uid else { return false }
            
            do {
                 return try await favoritesService.isCarInFavorites(carId: carId, userId: userId)
            } catch {
                return false
            }
    }
    
    // MARK: - Data Management
    func refreshCars() async {
        isLoading = true
        
        do {
            cars = try await carService.fetchCars(limit: 20)
        } catch {
            self.error = "Ошибка обновления"
        }
        
        isLoading = false
    }
    
    func clearFilters() {
        searchText = ""
        selectedBrand = nil
        selectedYear = nil
        loadCars()
    }
    
    func getUniqueBrands() -> [String] {
        let brands = cars.map { $0.brand }
        return Array(Set(brands)).sorted()
    }
    
    func getUniqueYears() -> [Int] {
        let years = cars.map { $0.year }
        return Array(Set(years)).sorted(by: >)
    }
}
