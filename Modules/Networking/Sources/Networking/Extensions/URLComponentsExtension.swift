//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

extension URLComponents {
    static public var `default`: Self {
        var components: Self = .init()
        components.scheme = Constants.baseScheme
        components.host = Constants.baseHost
        return components
    }
}
