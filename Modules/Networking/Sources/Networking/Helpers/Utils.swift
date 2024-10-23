//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

final class Utils {
    /// Метод создает объект [URLQueryItem] из переданной структуры, подписанной под протокол Encodable.
    /// - Parameter object: Объект структуры, подписанной под протокол Encodable.
    /// - Returns: Объект [URLQueryItem].
    static func createURLQueryItems<T: Encodable>(from object: T) -> [URLQueryItem]? {
        do {
            let json = try JSONEncoder().encode(object)
            let dictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
            return dictionary?.map { URLQueryItem(name: $0, value: "\($1)") }
        } catch {
            return nil
        }
    }
}
