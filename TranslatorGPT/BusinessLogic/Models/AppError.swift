//
//  AppError.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//

import Foundation

enum AppError: LocalizedError {
    case responseEmpty
    case emptyTextToTranslate
    case serverError(String)
    case decode
    
    var failureReason: String? {
        switch self {
        case .responseEmpty:
            return "Response empty"
        case .emptyTextToTranslate:
            return "Empty text to translate"
        case .serverError:
            return "Server error"
        case .decode:
            return "Decode error"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .responseEmpty:
            return "ChatGPT response is empty. Try again later"
        case .emptyTextToTranslate:
            return "You need to enter text to translate"
        case .serverError(let description):
            return "Server returned error: \(description)"
        case .decode:
            return "Error occured while decoding ChatGPT response"
        }
    }
}
