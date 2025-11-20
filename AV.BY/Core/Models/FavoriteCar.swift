//
//  FavoriteCar.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation

struct FavoriteCar: Codable, Identifiable {
    let id: String
    let carId: String
    let userId: String
    let addedAt: Date
    var car: Car?
    
    enum CodingKeys: String, CodingKey {
        case id
        case carId = "car_id"
        case userId = "user_id"
        case addedAt = "added_at"
        case car
    }
}
