//
//  AuthViewModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 27.10.25.
//

import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Published Properties
    @Published var selectedTab = 0
    @Published var selectedTabAuth = 0
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var password = ""
    @Published var isLoading = false
    
    // MARK: - Validation States
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    @Published var passwordError: String?
    
    // MARK: - Computed Properties
    var isLoginMode: Bool { selectedTab == 0 }
    var isPhoneAuth: Bool { selectedTabAuth == 0 }
    var isFormValid: Bool {
        isLoginMode ? isLoginFormValid : isRegistrationFormValid
    }
    
    // MARK: - Validation Logic
    private var isLoginFormValid: Bool {
        if isPhoneAuth {
            return !phone.isEmpty && isPhoneValid && !password.isEmpty
        } else {
            return !email.isEmpty && isEmailValid && !password.isEmpty
        }
    }
    
    private var isRegistrationFormValid: Bool {
        guard !name.isEmpty && isNameValid else { return false }
        
        if isPhoneAuth {
            return !phone.isEmpty && isPhoneValid && !password.isEmpty && isPasswordValid
        } else {
            return !email.isEmpty && isEmailValid && !password.isEmpty && isPasswordValid
        }
    }
    
    private var isNameValid: Bool { name.count >= 2 }
    private var isEmailValid: Bool {
        let regex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    private var isPhoneValid: Bool { phone.filter(\.isNumber).count == 9 }
    private var isPasswordValid: Bool { password.count >= 6 }
    
    // MARK: - Actions
    
    func login() async -> Result<Bool, Error> {
        guard isFormValid else {
            validateForm()
            return .failure(AuthError.invalidForm)
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            if isPhoneAuth {
                try await authService.loginWithPhone(phone: phone, password: password)
            } else {
                try await authService.login(email: email, password: password)
            }
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func register() async -> Result<Bool, Error> {
        guard isFormValid else {
            validateForm()
            return .failure(AuthError.invalidForm)
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            _ = try await authService.register(email: email, password: password, name: name)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func resetPassword() async -> Result<Bool, Error> {
        guard !email.isEmpty && isEmailValid else {
            return .failure(AuthError.invalidEmail)
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await authService.resetPassword(email: email)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Validation
    func validateForm() {
        if !isLoginMode { validateName() }
        validateEmail()
        validatePhone()
        validatePassword()
    }
    
    private func validateName() {
        nameError = name.isEmpty ? nil : (!isNameValid ? "Имя должно содержать минимум 2 символа" : nil)
    }
    
    private func validateEmail() {
        guard !isPhoneAuth else { emailError = nil; return }
        emailError = email.isEmpty ? nil : (!isEmailValid ? "Введите корректный email" : nil)
    }
    
    private func validatePhone() {
        guard isPhoneAuth else { phoneError = nil; return }
        phoneError = phone.isEmpty ? nil : (!isPhoneValid ? "Введите корректный номер телефона" : nil)
    }
    
    private func validatePassword() {
        passwordError = password.isEmpty ? nil : (!isPasswordValid ? "Пароль должен содержать минимум 6 символов" : nil)
    }
    
    // MARK: - Clear
    func clearForm() {
        name = ""
        email = ""
        phone = ""
        password = ""
        nameError = nil
        emailError = nil
        phoneError = nil
        passwordError = nil
    }
}
