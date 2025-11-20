//
//  UserProfile.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation
import FirebaseCore

struct UserProfile {
    let id: String
    let email: String
    let name: String
    let phone: String?
    let favoritesCount: Int
    let viewedCarsCount: Int
    let searchesCount: Int
    let createdAt: Date
    let lastLoginAt: Date?
    
    static func fromDictionary(_ data: [String: Any]) throws -> UserProfile {
        guard let id = data["id"] as? String,
              let email = data["email"] as? String,
              let name = data["name"] as? String else {
            throw FirebaseError.invalidData
        }
        
        return UserProfile(
            id: id,
            email: email,
            name: name,
            phone: data["phone"] as? String,
            favoritesCount: data["favorites_count"] as? Int ?? 0,
            viewedCarsCount: data["viewed_cars_count"] as? Int ?? 0,
            searchesCount: data["searches_count"] as? Int ?? 0,
            createdAt: (data["created_at"] as? Timestamp)?.dateValue() ?? Date(),
            lastLoginAt: (data["last_login_at"] as? Timestamp)?.dateValue()
        )
    }
}
