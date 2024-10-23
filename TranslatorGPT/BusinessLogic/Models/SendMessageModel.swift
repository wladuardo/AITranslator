//
//  SendMessageModel.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//

import Foundation
import Networking

struct SendMessageModel {
    let role: String
    let chatModel: ChatGPTModel
    let content: String
    
    init(role: ChatGPTRoles, chatModel: ChatGPTModel, content: String) {
        self.role = role.rawValue
        self.chatModel = chatModel
        self.content = content
    }
}

extension ChatGPTSendRequest {
    init(model: SendMessageModel) {
        self.init(model: model.chatModel.rawValue,
                  temperature: Constants.defaultTemperature,
                  messages: [.init(role: model.role, content: model.content)],
                  stream: true)
    }
}
