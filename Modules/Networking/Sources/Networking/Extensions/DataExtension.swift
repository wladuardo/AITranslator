//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

extension Data {
    func decode<T: Decodable>(model: T.Type) -> T? {
        return try? JSONDecoder().decode(model, from: self)
    }
}
