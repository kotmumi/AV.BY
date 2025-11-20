//
//  AuthService.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import Foundation
import FirebaseAuth

protocol AuthServiceProtocol {
    var currentUser: User? { get }
    var isUserLoggedIn: Bool { get }
    func login(email: String, password: String) async throws
    func register(email: String, password: String, name: String) async throws -> User
    func resetPassword(email: String) async throws
    func loginWithPhone(phone: String, password: String) async throws
    func logout() throws
}

final class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    private init() {}
    
    // MARK: - Current User Info
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    var isUserLoggedIn: Bool {
        return currentUser != nil
    }
    
    var currentUserName: String? {
        return currentUser?.displayName
    }
    
    var currentUserEmail: String? {
        return currentUser?.email
    }
    
    var currentUserID: String? {
        return currentUser?.uid
    }
    
    // MARK: - Email / Password Auth
    
    func register(email: String, password: String, name: String) async throws -> User {
           let result = try await Auth.auth().createUser(withEmail: email, password: password)
           
           let changeRequest = result.user.createProfileChangeRequest()
           changeRequest.displayName = name
           try await changeRequest.commitChanges()
           
           // Create user document in Firestore
           try await UserService.shared.createUserProfile(
               userId: result.user.uid,
               email: email,
               name: name
           )
           
           return result.user
       }
       
       func login(email: String, password: String) async throws {
           let result = try await Auth.auth().signIn(withEmail: email, password: password)
           
           try await UserService.shared.updateUserLastLogin(userId: result.user.uid)
       }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Phone Auth (пример)
    
    func loginWithPhone(phone: String, password: String) async throws {
        throw AuthError.phoneAuthNotSupported
    }
}
