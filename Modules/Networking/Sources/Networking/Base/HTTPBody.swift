//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public struct HTTPBody {
    
    private let bodyDict: [String: String]?
    private let bodyData: Data?
    
    public var data: Data? {
        if let bodyDict = bodyDict {
            return try? JSONEncoder().encode(bodyDict)
        }
        if let bodyData = bodyData {
            return bodyData
        }
        return nil
    }
    
    public init(bodyDict: [String: String]?)  {
        self.bodyData = nil
        self.bodyDict = bodyDict
    }
    
    public init(bodyData: Data?) {
        self.bodyDict = nil
        self.bodyData = bodyData
    }
    
    /// Если нужно проинициализировать body с пустыми параметрами
    public init() {
        self.bodyData = nil
        self.bodyDict = nil
    }
    
}
