//
//  File.swift
//  
//
//  Created by Владислав Ковальский on 22.06.2023.
//

import Foundation

enum ChatGPTEndpoint {
    case sendMessage(params: ChatGPTSendRequest)
}

extension ChatGPTEndpoint: HTTPEndpointConfigurable {
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat/completions"
        }
    }
    
    var url: URL? {
        var components: URLComponents = .default
        components.queryItems = queryItems
        components.path += "/v1" + path
        return components.url
    }
    
    var method: HTTPRequestMethods {
        switch self {
        case .sendMessage:
            return .post
        }
    }
    
    var header: HTTPHeaders? {
        switch self {
        case .sendMessage:
            return ["Authorization": "Bearer \(Constants.chatGPTAPIKey)", "Content-Type": "application/json"]
        }
    }
    
    var body: HTTPBody {
        switch self {
        case .sendMessage(let params):
            return .init(bodyData: try? params.data())
        }
    }
    
    
}
