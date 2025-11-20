//
//  Car.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import FirebaseFirestore
import Foundation

struct Car: Codable, Identifiable {
    let id: String
    let brand: String
    let model: String
    let year: Int
    let price: Double
    //let ownerId: UserProfile
    let description: String
    let imageURLs: [String]
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case model
        case year
        case price
        case description
        case imageURLs = "image_url"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        brand = try container.decode(String.self, forKey: .brand)
        model = try container.decode(String.self, forKey: .model)
        year = try container.decode(Int.self, forKey: .year)
        
        // Обработка price (может быть Double или Int)
        if let priceDouble = try? container.decode(Double.self, forKey: .price) {
            price = priceDouble
        } else {
            let priceInt = try container.decode(Int.self, forKey: .price)
            price = Double(priceInt)
        }
        
        description = try container.decode(String.self, forKey: .description)
        imageURLs = try container.decode([String].self, forKey: .imageURLs)
        
        // Обработка даты
        let createdAtTimestamp = try container.decode(Timestamp.self, forKey: .createdAt)
        createdAt = createdAtTimestamp.dateValue()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(brand, forKey: .brand)
        try container.encode(model, forKey: .model)
        try container.encode(year, forKey: .year)
        try container.encode(price, forKey: .price)
        try container.encode(description, forKey: .description)
        try container.encode(imageURLs, forKey: .imageURLs)
        try container.encode(Timestamp(date: createdAt), forKey: .createdAt)
    }
}
