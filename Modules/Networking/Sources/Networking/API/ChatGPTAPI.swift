//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation
import OSLog

public protocol IChatGPTAPI {
    func sendMessage(params: ChatGPTSendRequest) async throws(HTTPRequestError) -> ChatGPTSendResponse
}

public final class ChatGPTAPI: HTTPClient, IChatGPTAPI {
    private let logger: Logger
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.logger = .init(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: ChatGPTAPI.self))
    }
    
    public func sendMessage(params: ChatGPTSendRequest) async throws(HTTPRequestError) -> ChatGPTSendResponse {
        return try await sendRequest(logger: logger, endpoint: ChatGPTEndpoint.sendMessage(params: params), responseModel: ChatGPTSendResponse.self)
    }
}
