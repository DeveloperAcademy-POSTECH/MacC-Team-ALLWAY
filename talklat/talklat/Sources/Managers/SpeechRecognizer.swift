//
//  SpeechRecognizer.swift
//  talklat
//
//  Created by 신정연 on 2023/10/05.
//

import Accelerate
import AVFoundation
import Foundation
import Speech
import SwiftUI

final class SpeechRecognizer: ObservableObject {
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    
    @Published var transcript: String = ""
    
    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?
    private var audioBuffers: [AVAudioPCMBuffer] = []
    private let signalExtractor = SignalExtractor()
    
    // 이 클래스를 처음 사용할 때, 마이크랑 음성 접근을 요청합니다.
    init() {
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))
        guard recognizer != nil else {
            transcribeFailed(RecognizerError.nilRecognizer)
            return
        }
        
        Task {
            do {
                guard await SFSpeechRecognizer.hasAuthorizationToRecognize() else {
                    throw RecognizerError.notAuthorizedToRecognize
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                transcribeFailed(error)
            }
        }
    }
    
    @MainActor
    public func startTranscribing() {
        Task {
            beginTranscribe()
        }
    }
    
    @MainActor
    public func stopAndResetTranscribing() {
        Task {
            stopAndResetTranscribe()
        }
    }
    
    // text 전환을 시작합니다.
    private func beginTranscribe() {
        guard let recognizer = recognizer, recognizer.isAvailable else {
            self.transcribeFailed(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                self?.recognitionHandler(
                    audioEngine: audioEngine,
                    result: result,
                    error: error
                )
            })
        } catch {
            self.stopAndResetTranscribe()
            self.transcribeFailed(error)
        }
    }

    
    private func stopAndResetTranscribe() {
        task?.cancel()
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: .duckOthers
        )
        try audioSession.setActive(
            true,
            options: .notifyOthersOnDeactivation
        )
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
            // weak self 추가함
        ) { [weak self] (
            buffer: AVAudioPCMBuffer,
            when: AVAudioTime
        ) in
            request.append(buffer)
            // 버퍼 저장 추가
            self?.audioBuffers.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    public func processAudioDate() {
        for buffer in audioBuffers {
            // 노이즈 제거 안할 시
//            self.request?.append(buffer)
            // ==== 노이즈 제거 할 시 =====
            let processedData = signalExtractor.process(buffer: buffer)
            // 노이즈가 제거된 오디오 데이터를 SFSpeechAudioBufferRecognitionRequest 객체에 추가
            if let processedDataBuffer = processedData.toBuffer() {
                self.request?.append(processedDataBuffer)
            } else {
                print("Error: Failed to convert processed data to buffer")
            }
            // ==== 노이즈 제거 할 시 =====
        }
        audioBuffers.removeAll()
    }
    
    private func recognitionHandler(
         audioEngine: AVAudioEngine,
         result: SFSpeechRecognitionResult?,
         error: Error?
    ) {
        let receivedFinalResult = result?.isFinal ?? false
        let receivedError = error != nil
        
        if receivedFinalResult || receivedError {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if let result = result {
            let recognizedText = result.bestTranscription.formattedString
            
            // 인식률 계산용 test
            let originalText = "이제 2023년이 되어버렸어. 시간 참 빠르다. 아이스 아메리카노 주세요. 크림말고 로션 주세요."
            let accuracy = calculateRecognitionAccuracy(originalText: originalText, recognizedText: recognizedText)
            print("인식률: \(accuracy)%")
            
            transcribe(recognizedText)
        } else if let error = error {
            // 에러 처리
        }
    }

    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            transcript = message
        }
    }
    
    nonisolated private func transcribeFailed(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        Task { @MainActor [errorMessage] in
            transcript = "<< \(errorMessage) >>"
        }
    }
    
    // 음성 인식 정확도를 측정하는 함수1
    private func levenshteinDistanceBetween(_ a: String, and b: String) -> Int {
        if a.count == 0 {
            return b.count
        }
        
        if b.count == 0 {
            return a.count
        }
        
        var matrix: [[Int]] = Array(repeating: Array(repeating: 0, count: b.count + 1), count: a.count + 1)
        
        for i in 1...a.count {
            matrix[i][0] = i
        }
        
        for j in 1...b.count {
            matrix[0][j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
                if Array(a)[i-1] == Array(b)[j-1] {
                    matrix[i][j] = matrix[i-1][j-1]
                } else {
                    matrix[i][j] = min(matrix[i-1][j], matrix[i][j-1], matrix[i-1][j-1]) + 1
                }
            }
        }
        
        return matrix[a.count][b.count]
    }
    
    // 음성 인식 정확도를 측정하는 함수2
    private func calculateRecognitionAccuracy(originalText: String, recognizedText: String) -> Double {
        let distance = levenshteinDistanceBetween(originalText, and: recognizedText)
        let maxLength = max(originalText.count, recognizedText.count)
        
        // 정확도를 백분율로 반환합니다.
        let accuracy = ((Double(maxLength) - Double(distance)) / Double(maxLength)) * 100.0
        return accuracy
    }


}

extension SFSpeechRecognizer {
    static func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}

extension AVAudioSession {
    public func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
}

extension Array where Element == Float {
    func toBuffer() -> AVAudioPCMBuffer? {
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)! // Sample rate와 channel에 맞게 조정 필요
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(self.count)) else { return nil }
        buffer.frameLength = AVAudioFrameCount(self.count)
        for i in 0..<self.count {
            buffer.floatChannelData?.pointee[i] = self[i]
        }
        return buffer
    }
}
