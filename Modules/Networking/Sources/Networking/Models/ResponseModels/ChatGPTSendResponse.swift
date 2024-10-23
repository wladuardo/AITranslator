//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

public struct ChatGPTSendResponse: Codable {
    public let id, object: String?
    public let created: Int?
    public let model: String?
    public let choices: [Choice]?
    public let usage: Usage?
}

// MARK: - Choice
public struct Choice: Codable {
    public let index: Int?
    public let finishReason: String?
    public let message: ChatGPTMessage

    enum CodingKeys: String, CodingKey {
        case index
        case finishReason = "finish_reason"
        case message
    }
}

// MARK: - Usage
public struct Usage: Codable {
    public let promptTokens, completionTokens, totalTokens: Int?

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
