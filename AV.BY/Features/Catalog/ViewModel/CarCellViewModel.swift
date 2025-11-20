//
//  CarCellViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 19.11.25.
//
import SwiftUI
import Combine

@MainActor
final class CarCellViewModel: ObservableObject {
    
    let car: Car
    @Published var isFavorite = false
    @Published var isLoading = false
    @Published var error: String?
    
    private let favoritesService = FavoritesService.shared
    private let authManager = AuthService.shared
    
    init(car: Car) {
        self.car = car
        loadFavoriteStatus()
    }
    
    func loadFavoriteStatus() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let favoriteStatus = try await isCarFavorite(carId: car.id)
                print("favoriteStatus = \(favoriteStatus) carId \(car.id)")
                await MainActor.run {
                    self.isFavorite = favoriteStatus
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = "Ошибка загрузки статуса избранного"
                    self.isLoading = false
                }
            }
        }
    }
    
    func toggleFavorite() {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        // Оптимистичное обновление
        let oldValue = isFavorite
        isFavorite.toggle()
        
        Task {
            do {
                guard let userId = authManager.currentUser?.uid else {
                    throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Для добавления в избранное авторизируйтесь"])
                }
                
                if oldValue {
                    try await favoritesService.removeFromFavorites(carId: car.id, userId: userId)
                } else {
                    try await favoritesService.addToFavorites(carId: car.id, userId: userId)
                    print("carId:\(car.id) userId: \(userId)")
                }
                
                await MainActor.run {
                    self.isLoading = false
                }
                
            } catch {
                await MainActor.run {
                    self.isFavorite = oldValue
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func isCarFavorite(carId: String) async throws -> Bool {
        guard let userId = authManager.currentUser?.uid else {
            return false
        }
        return try await favoritesService.isCarInFavorites(carId: carId, userId: userId)
    }
}
