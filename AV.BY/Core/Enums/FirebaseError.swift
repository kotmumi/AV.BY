//
//  FirebaseErrors.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 8.11.25.
//

import Foundation

enum FirebaseError: LocalizedError {
    case documentNotFound
    case invalidData
    case unauthorized
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .documentNotFound:
            return "Документ не найден"
        case .invalidData:
            return "Неверные данные"
        case .unauthorized:
            return "Неавторизованный доступ"
        case .networkError:
            return "Ошибка сети"
        }
    }
}
