//
//  CameraTextRecognizerView.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 24.10.2024.
//

import SwiftUI
import VisionKit
import Vision

struct CameraTextRecognizerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var recognizedText: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented, recognizedText: $recognizedText)
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scannerViewController: DataScannerViewController = .init(
            recognizedDataTypes: [.text()],
            qualityLevel: .accurate,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if !uiViewController.isScanning {
            try? uiViewController.startScanning()
        }
    }
    
    func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Self.Coordinator) {
        uiViewController.stopScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var recognizedText: String
        
        init(isPresented: Binding<Bool>, recognizedText: Binding<String>) {
            _isPresented = isPresented
            _recognizedText = recognizedText
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                self.recognizedText = text.transcript
                self.isPresented = false
            default:
                break
            }
        }
    }
}
