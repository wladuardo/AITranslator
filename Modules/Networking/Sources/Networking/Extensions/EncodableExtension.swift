//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

extension Encodable {
    func data(with encoder: JSONEncoder = .init(), formatting: JSONEncoder.OutputFormatting = .prettyPrinted) throws -> Data {
        encoder.outputFormatting = formatting
        return try encoder.encode(self)
    }
    func string(with encoder: JSONEncoder = .init()) throws -> String {
        try data(with: encoder).string!
    }
    func dictionary(with encoder: JSONEncoder = .init(),
                    options: JSONSerialization.ReadingOptions = []) throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: try data(with: encoder), options: options) as? [String: Any] ?? [:]
    }
}

extension Sequence where Element == UInt8 {
    var string: String? { String(bytes: self, encoding: .utf8) }
}
