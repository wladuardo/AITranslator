//
//  TranslatorViewModel.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//

import Foundation
import UIKit

final class TranslatorViewModel: ObservableObject {
    @Published var textToTranslate: String = ""
    @Published var translatedText: String = ""
    @Published var selectedLanguageToTranslate: Languages = .english
    @Published var isCopied: Bool = false
    @Published var isInProcess: Bool = false
    @Published var appError: AppError?
    
    private let networkService: NetworkingService
    
    init() {
        networkService = .init()
    }
    
    func translate() {
        Task { @MainActor in
            do {
                HapticFeedbackService.impact(style: .light)
                isInProcess.toggle()
                let translation = try await networkService.sendRequest(with: textToTranslate, targetLanguage: selectedLanguageToTranslate.rawValue)
                translatedText = translation.first?.value ?? ""
                isInProcess.toggle()
                HapticFeedbackService.notification(type: .success)
            } catch {
                isInProcess.toggle()
                appError = error as? AppError
                HapticFeedbackService.notification(type: .error)
            }
        }
    }
    
    func copyAction() {
        Task { @MainActor in
            guard !translatedText.isEmpty else { return }
            UIPasteboard.general.string = translatedText
            isCopied.toggle()
            HapticFeedbackService.notification(type: .success)
            try await Task.sleep(for: .seconds(2))
            isCopied.toggle()
        }
    }
}
