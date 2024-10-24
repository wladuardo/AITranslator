//
//  TranslatorScreen.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//

import SwiftUI

struct TranslatorScreen: View {
    @StateObject private var viewModel: TranslatorViewModel = .init()
    @FocusState private var isFocused: Bool
    @State private var isAlertPresented: Bool = false
    @State private var isCameraPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.top)
                .padding(.horizontal)
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    HStack(alignment: .top) {
                        Text(viewModel.translatedText)
                            .textSelection(.enabled)
                            .lineLimit(nil)
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        copyButton
                    }
                    .padding(8)
                    .overlay(textEditorBorder)
                    .blur(radius: blurRadius)
                    .padding(.top)
                    
                    HStack {
                        languageMenu
                        Spacer()
                        translateButton
                    }
                    
                    HStack(alignment: .top) {
                        TextEditor(text: $viewModel.textToTranslate)
                            .submitLabel(.done)
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(textEditorPromt)
                            .focused($isFocused)
                            .submitLabel(.done)
                            .onChange(of: viewModel.textToTranslate) { onSubmitTextEditor() }
                        editButtons
                    }
                    .padding(8)
                    .overlay(textEditorBorder)
                    .blur(radius: blurRadius)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .onTapGesture { isFocused = false }
        .animation(.bouncy, value: viewModel.translatedText)
        .animation(.bouncy, value: viewModel.isCopied)
        .animation(.bouncy, value: viewModel.isInProcess)
        .disabled(viewModel.isInProcess)
        .sheet(isPresented: $isCameraPresented) { CameraTextRecognizerView(isPresented: $isCameraPresented, recognizedText: $viewModel.textToTranslate) }
        .alert(viewModel.appError?.failureReason ?? "", isPresented: $isAlertPresented) {
            Button("OK") { isAlertPresented.toggle() }
        } message: {
            Text(viewModel.appError?.errorDescription ?? "")
        }
        .onReceive(viewModel.$appError) { error in
            guard error != nil else { return }
            isAlertPresented.toggle()
        }
    }
}

private extension TranslatorScreen {
    var blurRadius: CGFloat {
        return viewModel.isInProcess ? 2 : 0
    }
    
    var textEditorBorder: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(.linearGradient(colors: [.blue, .primary],
                                    startPoint: .leading,
                                    endPoint: .trailing),
                    lineWidth: 1.5)
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("AI Translator")
                .font(.system(size: 35, weight: .black))
                .foregroundStyle(.linearGradient(colors: [.blue, .primary],
                                                 startPoint: .leading,
                                                 endPoint: .trailing))
            HStack {
                Text("Powered by ChatGPT")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.linearGradient(colors: [.gray, .primary],
                                                     startPoint: .leading,
                                                     endPoint: .trailing))
                Image(.chatGPTLogo)
                    .resizable()
                    .frame(width: 25, height: 25)
                Spacer()
            }
        }
    }
    
    var languageMenu: some View {
        Menu {
            Picker("", selection: $viewModel.selectedLanguageToTranslate) {
                ForEach(Languages.allCases, id: \.rawValue) { language in
                    Text(language.rawValue.capitalized)
                        .tag(language)
                }
            }
        } label: {
            Text("Translate to: \(viewModel.selectedLanguageToTranslate.rawValue.capitalized)")
                .padding(8)
                .font(.system(size: 15, weight: .semibold))
                .background(.gray.opacity(0.2))
                .clipShape(.rect(cornerRadius: 10))
        }
        .blur(radius: blurRadius)
    }
    
    var copyButton: some View {
        Button {
            viewModel.copyAction()
        } label: {
            Image(systemName: viewModel.isCopied
                  ? "checkmark"
                  : "rectangle.portrait.on.rectangle.portrait.fill")
                .font(.system(size: 15, weight: .semibold))
        }
    }
    
    var textEditorPromt: some View {
        HStack {
            if viewModel.textToTranslate.isEmpty {
                Text("Enter text you want to translate")
                    .foregroundColor(.gray.opacity(0.5))
                    .font(.system(size: 15, weight: .semibold))
                Spacer()
            }
        }
        .padding(.leading, 4)
    }
    
    var editButtons: some View {
        HStack(spacing: 16) {
            Button {
                isFocused = false
                isCameraPresented.toggle()
                HapticFeedbackService.impact(style: .light)
            } label: {
                Image(systemName: "camera.fill")
                    .font(.system(size: 15, weight: .semibold))
            }
            
            Button {
                guard let pasteboardString = UIPasteboard.general.string else { return }
                isFocused = false
                viewModel.textToTranslate += pasteboardString
                HapticFeedbackService.impact(style: .light)
            } label: {
                Image(systemName: "document.on.clipboard.fill")
                    .font(.system(size: 15, weight: .semibold))
            }

            Button {
                isFocused = false
                viewModel.textToTranslate.removeAll()
                HapticFeedbackService.impact(style: .light)
            } label: {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 15, weight: .semibold))
            }
        }
        .padding(.top, 4)
    }
    
    var translateButton: some View {
        Button {
            isFocused = false
            viewModel.translate()
        } label: {
            HStack {
                if viewModel.isInProcess {
                    ProgressView()
                        .tint(.blue)
                } else {
                    Text("Translate")
                    Image(systemName: "translate")
                }
            }
            .padding(8)
            .font(.system(size: 15, weight: .semibold))
            .background(.gray.opacity(0.2))
            .clipShape(.rect(cornerRadius: 10))
        }
        
    }
    
    func onSubmitTextEditor() {
        guard viewModel.textToTranslate.last?.isNewline == .some(true) else { return }
        viewModel.textToTranslate.removeLast()
        isFocused = false
    }
}
