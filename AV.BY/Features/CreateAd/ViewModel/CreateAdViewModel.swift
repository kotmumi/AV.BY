//
//  CreateAdViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import Foundation
import Combine

@MainActor
final class CreateAdViewModel: ObservableObject {
    
    @Published var isAuth = true
    @Published var isLoading = false
    @Published var error: String?
    @Published var userAds: [Car] = []
    
    private let authManager = AuthManager()
    private let carService = CarService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthObserver()
        checkAuthStatus()
    }
    
    private func setupAuthObserver() {
        authManager.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.isAuth = isLoggedIn
                if isLoggedIn {
                    self?.loadUserAds()
                } else {
                    self?.userAds = []
                }
            }
            .store(in: &cancellables)
    }
    
    func checkAuthStatus() {
        isAuth = authManager.isLoggedIn
        if isAuth {
            loadUserAds()
        }
    }
    
    func loadUserAds() {
        guard let _ = authManager.currentUser?.uid else {
            userAds = []
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                // Загружаем все автомобили и фильтруем по владельцу
                let _ = try await carService.fetchCars(limit: 100)
              //  userAds = allCars.filter { $0.ownerId == userId }
            } catch {
                self.error = "Ошибка загрузки объявлений"
                print("Error loading user ads: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func createNewAd(brand: String, model: String, year: Int, price: Double, description: String, imageURLs: [String]) async throws -> String {
        guard let userId = authManager.currentUser?.uid else {
            throw CreateAdError.unauthorized
        }
        
        let carData = CarCreateData(
            brand: brand,
            model: model,
            year: year,
            price: price,
            description: description,
            imageURLs: imageURLs
        )
        
        return try await carService.addNewCar(carData, ownerId: userId)
    }
    
    func deleteAd(carId: String) async throws {
        // Здесь нужно добавить метод удаления в CarService
        // Пока что это заглушка
        throw CreateAdError.notImplemented
    }
    
    func refreshAds() async {
         loadUserAds()
    }
}
