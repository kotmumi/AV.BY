//
//  FavoritesViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    
    @Published var selectedTab = 0
    @Published var isAuth = false
    @Published var favoriteCars: [Car] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let authManager = AuthManager()
    private let favoritesService = FavoritesService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAuthObserver()
    }
    
    private func setupAuthObserver() {
        authManager.$isLoggedIn
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoggedIn in
                self?.isAuth = isLoggedIn
                if isLoggedIn {
                    self?.loadFavorites()
                } else {
                    self?.clearData()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadFavorites() {
        guard let userId = authManager.currentUser?.uid else { return }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                favoriteCars = try await favoritesService.fetchUserFavorites(userId: userId)
            } catch {
                self.error = "Ошибка загрузки избранного"
                print("Error loading favorites: \(error)")
            }
            isLoading = false
        }
    }
    
    func removeFromFavorites(carId: String) {
        guard let userId = authManager.currentUser?.uid else { return }
        
        Task {
            do {
                try await favoritesService.removeFromFavorites(carId: carId, userId: userId)
                // Удаляем из локального массива после успешного удаления из БД
                await MainActor.run {
                    favoriteCars.removeAll { $0.id == carId }
                }
            } catch {
                self.error = "Ошибка удаления из избранного"
            }
        }
    }
    
    func toggleFavorite(carId: String) {
        guard let userId = authManager.currentUser?.uid else {
            error = "Для работы с избранным需要 авторизация"
            return
        }
        
        Task {
            do {
                let isFavorite = favoriteCars.contains { $0.id == carId }
                
                if isFavorite {
                    try await favoritesService.removeFromFavorites(carId: carId, userId: userId)
                    await MainActor.run {
                        favoriteCars.removeAll { $0.id == carId }
                    }
                } else {
                    try await favoritesService.addToFavorites(carId: carId, userId: userId)
                    // После добавления нужно загрузить данные автомобиля
                    if let car = try? await CarService.shared.fetchCar(by: carId) {
                        await MainActor.run {
                            favoriteCars.insert(car, at: 0) // Добавляем в начало
                        }
                    }
                }
            } catch {
                self.error = "Ошибка обновления избранного"
            }
        }
    }
    
    private func clearData() {
        favoriteCars = []
    }
    
    func refreshData() async {
        if isAuth {
            await loadFavoritesAsync()
        }
    }
    
    private func loadFavoritesAsync() async {
        guard let userId = authManager.currentUser?.uid else { return }
        
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        do {
            let cars = try await favoritesService.fetchUserFavorites(userId: userId)
            await MainActor.run {
                self.favoriteCars = cars
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = "Ошибка загрузки избранного"
                isLoading = false
            }
        }
    }
}
