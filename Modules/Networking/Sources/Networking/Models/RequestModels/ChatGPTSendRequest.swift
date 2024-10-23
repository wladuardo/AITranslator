//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public struct ChatGPTSendRequest: Codable {
    public let model: String
    public let messages: [ChatGPTMessage]
    
    public init(model: String,
                temperature: Double,
                messages: [ChatGPTMessage],
                stream: Bool) {
        self.model = model
        self.messages = messages
    }
}

public struct ChatGPTMessage: Codable {
    public let role: String?
    public let content: String?
    
    public init(role: String,
                content: String) {
        self.role = role
        self.content = content
    }
}

