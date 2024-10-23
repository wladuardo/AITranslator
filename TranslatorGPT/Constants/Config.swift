//
//  Config.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//


import Foundation

enum Config {
    static let responseDescription  = ". I need you to always respond in strict JSON format without any additional characters or words. The response should be pure JSON, where the key is a short abbreviation for the translation language and the value is the translation itself. Ensure that the output is prepared as JSON and does not contain any extra symbols or words."
    static let promtInstruction = { (textToTranslate: String) in
        return "Translate this text: '\(textToTranslate)' to"
    }
}
