//
//  UserService.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func createUserProfile(userId: String, email: String, name: String) async throws
    func fetchUserProfile(userId: String) async throws -> UserProfile
    func updateUserProfile(userId: String, name: String?, phone: String?) async throws
    func updateUserLastLogin(userId: String) async throws
    func incrementUserStats(userId: String, field: UserStatsField) async throws
}

final class UserService: UserServiceProtocol {
    static let shared = UserService()
    private init() {}
    
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    
    func createUserProfile(userId: String, email: String, name: String) async throws {
        let userData: [String: Any] = [
            "id": userId,
            "email": email,
            "name": name,
            "phone": "",
            "favorites_count": 0,
            "viewed_cars_count": 0,
            "searches_count": 0,
            "created_at": FieldValue.serverTimestamp(),
            "last_login_at": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp()
        ]
        
        try await db.collection(usersCollection).document(userId).setData(userData)
    }
    
    func fetchUserProfile(userId: String) async throws -> UserProfile {
        let document = try await db.collection(usersCollection).document(userId).getDocument()
        
        guard let data = document.data() else {
            throw FirebaseError.documentNotFound
        }
        
        return try UserProfile.fromDictionary(data)
    }
    
    func updateUserProfile(userId: String, name: String?, phone: String?) async throws {
        var updateData: [String: Any] = [:]
        
        if let name = name {
            updateData["name"] = name
        }
        if let phone = phone {
            updateData["phone"] = phone
        }
        
        updateData["updated_at"] = FieldValue.serverTimestamp()
        
        try await db.collection(usersCollection).document(userId).updateData(updateData)
    }
    
    func updateUserLastLogin(userId: String) async throws {
        try await db.collection(usersCollection).document(userId).updateData([
            "last_login_at": FieldValue.serverTimestamp()
        ])
    }
    
    func incrementUserStats(userId: String, field: UserStatsField) async throws {
        try await db.collection(usersCollection).document(userId).updateData([
            field.rawValue: FieldValue.increment(Int64(1))
        ])
    }
}

