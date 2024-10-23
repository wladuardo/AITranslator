//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

extension Int {
    var localStatusCode: String {
        return HTTPURLResponse.localizedString(forStatusCode: self)
    }
    
    var str: String {
        return String(self)
    }
}
