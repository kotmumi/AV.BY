//
//  HomeViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var totalCarsCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var filterViewModel = FilterViewModel()
    private let carService = CarService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadTotalCarsCount()
    }
    
    func loadTotalCarsCount() {
        isLoading = true
        error = nil
        
        Task {
            do {
                // Загружаем все автомобили без лимита для подсчета
                let allCars = try await carService.fetchCars(limit: 1000) // Большой лимит для подсчета
                totalCarsCount = allCars.count
            } catch {
                self.error = "Ошибка загрузки данных"
                print("Error loading cars count: \(error)")
                // Устанавливаем дефолтное значение при ошибке
                totalCarsCount = 91712
            }
            
            isLoading = false
        }
    }
    
    func refreshData() {
        loadTotalCarsCount()
    }
    
    // Форматирование числа с пробелами
    func formattedCarsCount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: totalCarsCount)) ?? "\(totalCarsCount)"
    }
}
