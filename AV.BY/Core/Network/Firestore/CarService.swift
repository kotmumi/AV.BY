//
//  FirestoreDatabaseService.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation
import FirebaseFirestore

protocol CarServiceProtocol {
    func fetchCars(limit: Int) async throws -> [Car]
    func fetchCar(by id: String) async throws -> Car
    func searchCars(brand: String?, model: String?, minYear: Int?, maxYear: Int?, minPrice: Double?, maxPrice: Double?) async throws -> [Car]
    func addNewCar(_ car: CarCreateData, ownerId: String) async throws -> String
    func getTotalCarsCount() async throws -> Int
}

final class CarService: CarServiceProtocol {
    static let shared = CarService()
    private init() {}
    
    private let db = Firestore.firestore()
    private let carsCollection = "cars"
    
    func fetchCars(limit: Int = 20) async throws -> [Car] {
        let snapshot = try await db.collection(carsCollection)
            .order(by: "created_at", descending: true)
            .limit(to: limit)
            .getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: Car.self)
        }
    }
    
    func getTotalCarsCount() async throws -> Int {
         let snapshot = try await db.collection(carsCollection).getDocuments()
         return snapshot.documents.count
     }
    
    func fetchCar(by id: String) async throws -> Car {
        let document = try await db.collection(carsCollection).document(id).getDocument()
        
        guard let car = try? document.data(as: Car.self) else {
            throw NSError(domain: "CarService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Car not found"])
        }
        
        return car
    }
    
    func searchCars(
        brand: String? = nil,
        model: String? = nil,
        minYear: Int? = nil,
        maxYear: Int? = nil,
        minPrice: Double? = nil,
        maxPrice: Double? = nil
    ) async throws -> [Car] {
        var query: Query = db.collection(carsCollection)
        
        if let brand = brand, !brand.isEmpty {
            query = query.whereField("brand", isEqualTo: brand)
        }
        
        if let model = model, !model.isEmpty {
            query = query.whereField("model", isEqualTo: model)
        }
        
        if let minYear = minYear {
            query = query.whereField("year", isGreaterThanOrEqualTo: minYear)
        }
        
        if let maxYear = maxYear {
            query = query.whereField("year", isLessThanOrEqualTo: maxYear)
        }
        
        if let minPrice = minPrice {
            query = query.whereField("price", isGreaterThanOrEqualTo: minPrice)
        }
        
        if let maxPrice = maxPrice {
            query = query.whereField("price", isLessThanOrEqualTo: maxPrice)
        }
        
        let snapshot = try await query
            .order(by: "created_at", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: Car.self)
        }
    }
    
    func addNewCar(_ car: CarCreateData, ownerId: String) async throws -> String {
        let carId = UUID().uuidString
        let carData: [String: Any] = [
            "id": carId,
            "brand": car.brand,
            "model": car.model,
            "year": car.year,
            "price": car.price,
            "description": car.description,
            "image_url": car.imageURLs,
            "owner_id": ownerId,
            "created_at": FieldValue.serverTimestamp()
        ]
        
        try await db.collection(carsCollection).document(carId).setData(carData)
        return carId
    }
}

extension CarService {
    func searchCars(
        brands: [String]? = nil,
        models: [String: [String]]? = nil,
        minPrice: Int? = nil,
        maxPrice: Int? = nil,
        minYear: Int? = nil,
        maxYear: Int? = nil,
        minMileage: Int? = nil,
        maxMileage: Int? = nil,
        fuelTypes: [String]? = nil,
        transmissions: [String]? = nil,
        bodyTypes: [String]? = nil
    ) async throws -> [Car] {
      return []
    }
}
