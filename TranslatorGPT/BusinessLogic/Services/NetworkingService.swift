//
//  NetworkingService.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//


import Foundation
import Networking
import OSLog

final class NetworkingService {    
    private let networkService: NetworkService
    private let logger: Logger
    
    init() {
        self.networkService = .init()
        self.logger = .init(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: NetworkService.self))
    }
    
    func sendRequest(with textToTranslate: String, targetLanguage: String) async throws(AppError) -> [String: String] {
        do {
            guard !textToTranslate.isEmpty else { throw AppError.emptyTextToTranslate }
            let choices = try await sendMessage(with: textToTranslate, language: targetLanguage)
            guard let response = choices?.first else { throw AppError.responseEmpty }
            logger.debug("👍 ChatGPT response: \(response)")
            return try decodeJsonString(response)
        } catch {
            logger.error("👎 Error on sending message: \(error)")
            throw error as! AppError
        }
    }
}

private extension NetworkingService {
    func sendMessage(with textToTranslate: String, language: String) async throws(AppError) -> [String]? {
        do {
            let model: SendMessageModel = .init(role: .user, chatModel: .chatGPT4oMini, content: getPromt(with: textToTranslate, language: language))
            let requestModel: ChatGPTSendRequest = .init(model: model)
            let result = try await networkService.chatGPTAPI.sendMessage(params: requestModel)
            let choices: [String]? = result.choices?.compactMap { return $0.message.content }
            return choices
        } catch {
            throw .serverError(error.localizedDescription)
        }
    }
    
    func getPromt(with textToTranslate: String, language: String) -> String {
        var promtString: String = Config.promtInstruction(textToTranslate)
        promtString += " " + language
        promtString.append(contentsOf: Config.responseDescription)
        return promtString
    }
    
    func decodeJsonString(_ jsonString: String) throws(AppError) -> [String: String] {
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw .decode
        }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: String] else {
            throw .decode
        }
        
        return jsonObject
    }
}
