//
//  AuthErrors.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidForm
    case invalidEmail
    case networkError
    case phoneAuthNotSupported
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "Заполните все поля корректно"
        case .invalidEmail:
            return "Введите корректный email"
        case .networkError:
            return "Ошибка сети. Попробуйте позже"
        case .phoneAuthNotSupported:
            return "Авторизация по телефону пока не реализована"
        }
    }
}
