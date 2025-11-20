//
//  AuthManager.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 3.11.25.
//

import Foundation
import FirebaseAuth

@MainActor
final class AuthManager: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = true
    @Published var userProfile: UserProfile?
    
    private let authService = AuthService.shared
    private let userService = UserService.shared
    
    init() {
        setupAuthListener()
    }
    
    private func setupAuthListener() {
       _ = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.currentUser = user
                self?.isLoggedIn = user != nil
                
                if let user = user {
                    self?.loadUserProfile(userId: user.uid)
                } else {
                    self?.userProfile = nil
                }
            }
        }
    }
    
    private func loadUserProfile(userId: String) {
        Task {
            do {
                userProfile = try await userService.fetchUserProfile(userId: userId)
            } catch {
                print("Error loading user profile: \(error)")
            }
        }
    }
    
    // Быстрая проверка без listener
    func checkAuthStatus() {
        isLoading = false
        currentUser = authService.currentUser
        isLoggedIn = authService.isUserLoggedIn
    }
    
    func logout() {
        do {
            try authService.logout()
            isLoggedIn = false
            currentUser = nil
        } catch {
            print("Logout error: \(error)")
        }
    }
}
