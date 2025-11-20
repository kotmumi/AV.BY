//
//  AdCarError.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 19.11.25.
//

import Foundation

enum AdCarError: LocalizedError {
    case invalidForm
    case unauthorized
    case invalidData
    case imageUploadFailed
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "Заполните все обязательные поля и добавьте фотографии"
        case .unauthorized:
            return "Требуется авторизация"
        case .invalidData:
            return "Неверные данные в форме"
        case .imageUploadFailed:
            return "Ошибка загрузки фотографий"
        case .networkError:
            return "Ошибка сети"
        }
    }
}
