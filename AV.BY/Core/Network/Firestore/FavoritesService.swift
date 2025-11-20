//
//  FavoritesService.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation
import FirebaseFirestore

protocol FavoritesServiceProtocol {
    func addToFavorites(carId: String, userId: String) async throws
    func removeFromFavorites(carId: String, userId: String) async throws
    func fetchUserFavorites(userId: String) async throws -> [Car]
    func isCarInFavorites(carId: String, userId: String) async throws -> Bool
    func addFavoritesListener(userId: String, completion: @escaping (Result<[Car], Error>) -> Void) -> ListenerRegistration
}

final class FavoritesService: FavoritesServiceProtocol {
    static let shared = FavoritesService()
    private init() {}
    
    private let db = Firestore.firestore()
    private let favoritesCollection = "favorites"
    
    func addToFavorites(carId: String, userId: String) async throws {
        let favoriteId = "\(userId)_\(carId)"
        let favoriteData: [String: Any] = [
            "id": favoriteId,
            "car_id": carId,
            "user_id": userId,
            "added_at": FieldValue.serverTimestamp()
        ]
        
        try await db.collection(favoritesCollection).document(favoriteId).setData(favoriteData)
        
        // Update user favorites count
        try await UserService.shared.incrementUserStats(userId: userId, field: .favoritesCount)
    }
    
    func removeFromFavorites(carId: String, userId: String) async throws {
        let favoriteId = "\(userId)_\(carId)"
        
        try await db.collection(favoritesCollection).document(favoriteId).delete()
        
        // Update user favorites count (decrement)
        try await db.collection("users").document(userId).updateData([
            "favorites_count": FieldValue.increment(Int64(-1))
        ])
    }
    
    func fetchUserFavorites(userId: String) async throws -> [Car] {
        let snapshot = try await db.collection(favoritesCollection)
            .whereField("user_id", isEqualTo: userId)
            .order(by: "added_at", descending: true)
            .getDocuments()
        
        let favorites = try snapshot.documents.compactMap { document in
            try document.data(as: FavoriteCar.self)
        }
        print("favorite: \(favorites)")
        // Fetch car details for each favorite
        var cars: [Car] = []
        for favorite in favorites {
            if let car = try? await CarService.shared.fetchCar(by: favorite.carId) {
                cars.append(car)
            }
        }
        
        return cars
    }
    
    func isCarInFavorites(carId: String, userId: String) async throws -> Bool {
        let favoriteId = "\(userId)_\(carId)"
        print("favoriteId - \(favoriteId)")
        let document = try await db.collection(favoritesCollection).document(favoriteId).getDocument()
        return document.exists
    }
    
    func addFavoritesListener(userId: String, completion: @escaping (Result<[Car], Error>) -> Void) -> ListenerRegistration {
        return db.collection(favoritesCollection)
            .whereField("user_id", isEqualTo: userId)
            .order(by: "added_at", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let favorites = documents.compactMap { document in
                    try? document.data(as: FavoriteCar.self)
                }
                
                // Загружаем данные автомобилей асинхронно
                Task {
                    var cars: [Car] = []
                    for favorite in favorites {
                        if let car = try? await CarService.shared.fetchCar(by: favorite.carId) {
                            cars.append(car)
                        }
                    }
                    
                    await MainActor.run {
                        completion(.success(cars))
                    }
                }
            }
    }
}
