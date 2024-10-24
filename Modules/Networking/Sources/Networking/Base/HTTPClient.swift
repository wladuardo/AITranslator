//
//  File.swift
//
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation
import OSLog

public protocol HTTPClient: AnyObject {
    func sendRequest<T: Decodable>(session: URLSession,
                                   logger: Logger,
                                   endpoint: any HTTPEndpoint,
                                   responseModel: T.Type) async throws(HTTPRequestError) -> T
}

public extension HTTPClient {
    func sendRequest<T: Decodable>(session: URLSession = .shared,
                                   logger: Logger,
                                   endpoint: any HTTPEndpoint,
                                   responseModel: T.Type) async throws(HTTPRequestError) -> T {
        guard let url = endpoint.url else { throw .invalidURL }
        var request: URLRequest = .init(url: url, timeoutInterval: 60)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.httpBody = endpoint.body.data
        
        loggerRequest(request: request, logger: logger)
        return try await dataTask(with: session, and: request, responseModel: responseModel)
    }
    
    /// Вспомогательный метод, который делает запрос из готового URLRequest.
    func dataTask<T: Decodable>(with session: URLSession,
                                and request: URLRequest,
                                responseModel: T.Type) async throws(HTTPRequestError) -> T {
        
        do {
            let result = try await session.data(for: request)
            return try await handlingDataTask(data: result.0, response: result.1, responseModel: responseModel)
        } catch {
            throw .noResponse
        }
    }
    
    /// Вспомогательный метод, который обрабатывает ответ от запроса.
    func handlingDataTask<T: Decodable>(data: Data?,
                                        response: URLResponse?,
                                        responseModel: T.Type) async throws(HTTPRequestError) -> T {
        guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { throw .noResponse }
        
        switch responseCode {
        case 200...299:
            if responseModel is Data.Type {
                return responseModel as! T
            }

            guard let decodedData = data?.decode(model: responseModel) else { throw .decode }
            return decodedData
        case 400:
            if let decodeData = data?.decode(model: ValidatorErrorResponse.self) {
                throw .validator(error: decodeData)
            }
            throw .unexpectedStatusCode(code: responseCode, localized: responseCode.localStatusCode)
        case 401:
            throw .unauthorizate
        default:
            throw .unexpectedStatusCode(code: responseCode, localized: responseCode.localStatusCode)
        }
    }
}

// MARK: - Logging
private extension HTTPClient {
    /// Записывает детали переданного URLRequest в лог.
    /// - Parameters:
    ///   - request: Запрос, детали которого необходимо записать в лог.
    ///   - logger: Инструмент для логирования.
    func loggerRequest(request: URLRequest, logger: Logger) {
        let body: [String: Any] = extractRequestBody(request: request)
        
        logger.debug(
                """
                🛜 SEND REQUEST
                ____________________________________________
                URL: \(request.url?.absoluteString ?? "nil")
                HEADERS:
                \(request.allHTTPHeaderFields ?? [:], privacy: .private)
                METHOD: \(request.httpMethod ?? "nil")
                BODY:
                \(body, privacy: .private)
                ____________________________________________
                """
        )
    }
    
    /// Извлекает тело запроса в виде словаря. Если данные не являются JSON или отсутствуют, вернет строковое представление данных.
    /// - Parameter request: URLRequest, из которого необходимо извлечь тело.
    /// - Returns: Тело запроса в виде словаря [String: Any] или строковое представление данных.
    func extractRequestBody(request: URLRequest) -> [String: Any] {
        guard let data = request.httpBody else { return [:] }
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any], !jsonObject.isEmpty {
            return jsonObject
        } else {
            return ["noJsonData": String(data: data, encoding: .utf8) ?? ""]
        }
    }
}
