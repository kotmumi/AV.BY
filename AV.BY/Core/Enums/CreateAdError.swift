//
//  CreateAdError.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 9.11.25.
//

import Foundation

enum CreateAdError: LocalizedError {
    case unauthorized
    case notImplemented
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Требуется авторизация"
        case .notImplemented:
            return "Функция пока не реализована"
        case .networkError:
            return "Ошибка сети"
        }
    }
}
