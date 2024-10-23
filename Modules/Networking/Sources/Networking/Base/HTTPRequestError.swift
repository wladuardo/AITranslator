//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public struct ValidatorErrorResponse: Decodable, Sendable {
    let message, type: String
    let param: String?
    let code: Int?
}

public enum HTTPRequestError: Error {
    /// Ошибка декодирования модели
    case decode
    /// Ошибка проверки URL
    case invalidURL
    /// Ошибка получения ответа от сервера
    case noResponse
    /// Ошибка получения данных
    case request(localizedDiscription: String)
    /// Ошибка окончания текущей сессии
    case unauthorizate
    /// Ошибка для непредвиденных статус кодов
    case unexpectedStatusCode(code: Int, localized: String?)
    /// Ошибка обработки запроса сервером
    case defaultServerError(error: String)
    /// Ошибка отсутсвия загружаемых данных
    case noBodyData
    /// Ошибка валидации отправленных данных
    case validator(error: ValidatorErrorResponse)
}

extension HTTPRequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decode:
            return "Ошибка декодирования"
        case .invalidURL:
            return "Неверный URL"
        case .noResponse:
            return "Нет ответа"
        case .request(let localizedDiscription):
            return localizedDiscription
        case .unauthorizate:
            return "Сессия окончена"
        case .unexpectedStatusCode(let code, let local):
            return "unexpectedStatusCode: \(code) - " + (local ?? "")
        case .defaultServerError(error: let error):
            return "Ошибка сервера: " + error
        case .noBodyData:
            return "Нет передаваемых данных"
        case .validator(let error):
            return "Ошибка валидатора: \(error.message)"
        }
    }
}
