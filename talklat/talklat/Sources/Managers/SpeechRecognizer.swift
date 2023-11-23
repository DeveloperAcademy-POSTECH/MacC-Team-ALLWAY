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
        
        recognizer?.supportsOnDeviceRecognition = true
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
        stopAndResetTranscribe()
        
        guard let recognizer = recognizer,
              recognizer.isAvailable else {
            self.transcribeFailed(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        do {
            let (audioEngine, request) = try prepareEngine()
            self.audioEngine = audioEngine
            self.request = request
            self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                self?.recognitionHandler(
                    audioEngine: audioEngine,
                    result: result,
                    error: error
                )
            }
        } catch {
            self.stopAndResetTranscribe()
            self.transcribeFailed(error)
        }
    }
    
    private func stopAndResetTranscribe() {
        request?.endAudio()
        task?.cancel()
        audioEngine?.stop()
        transcript.removeAll(keepingCapacity: true)
        audioEngine = nil
        request = nil
        task = nil
    }
    
    private func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        
        request.addsPunctuation = true
        request.shouldReportPartialResults = true
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(
            .playAndRecord,
            mode: .measurement,
            options: .defaultToSpeaker
        )
        try audioSession.setActive(
            true,
            options: .notifyOthersOnDeactivation
        )
        
        try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak self] (
            buffer: AVAudioPCMBuffer,
            when: AVAudioTime
        ) in
            request.append(buffer)
            self?.audioBuffers.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
    
    public func processAudioData() {
        for buffer in audioBuffers {
            // MARK: 노이즈 제거 안할 때
//             self.request?.append(buffer)
            // MARK: 노이즈 제거할 때
            let processedData = signalExtractor.process(buffer: buffer)
            // 노이즈가 제거된 오디오 데이터를 SFSpeechAudioBufferRecognitionRequest 객체에 추가
            if let processedDataBuffer = processedData.toBuffer() {
                self.request?.append(processedDataBuffer)
            } else {
            // print("Error: Failed to convert processed data to buffer")
            }
        }
        audioBuffers.removeAll()
    }
    
    private func recognitionHandler(
         audioEngine: AVAudioEngine,
         result: SFSpeechRecognitionResult?,
         error: Error?
    ) {
        var isFinal = false
        
        if let result = result {
            let recognizedText = result.bestTranscription.formattedString
            transcribe(recognizedText)
            
            isFinal = result.isFinal
        } else if let error {
            print(error.localizedDescription)
        }
        
        if isFinal || error != nil {
            audioBuffers = []
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    public func addPunctuation(_ transcript: String) -> String {
        var modifiedTranscript = transcript
        var searchStartIndex = modifiedTranscript.startIndex
        
        for pattern in conversationPatterns.questionPatterns {
            var searchStartIndex = modifiedTranscript.startIndex
            
            while let range = modifiedTranscript.range(
                of: pattern,
                options: [],
                range: searchStartIndex..<modifiedTranscript.endIndex
            ) {
                if range.upperBound == modifiedTranscript.endIndex || modifiedTranscript[range.upperBound] != "?" {
                    modifiedTranscript.insert("?", at: range.upperBound)
                } else if range.upperBound == modifiedTranscript.endIndex || modifiedTranscript[range.upperBound] != "." {
                    modifiedTranscript.insert(".", at: range.upperBound)
                }
                searchStartIndex = modifiedTranscript.index(after: range.upperBound)
            }
        }
        
        return modifiedTranscript
    }

    nonisolated private func transcribe(_ message: String) {
        Task { @MainActor in
            let res = addPunctuation(message)
            transcript = res
        }
    }
    
    nonisolated private func transcribeFailed(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        // MARK: Answered Text에 에러 메시지가 쌓이지 않도록 후속 작업 각주 처리
//        Task { @MainActor _ in
//            transcript = "<< \(errorMessage) >>"
//        }
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

// 노이즈 제거할 때, 라이브 오디오 데이터 -> 버퍼 변환
extension Array where Element == Float {
    func toBuffer() -> AVAudioPCMBuffer? {
        // TODO: Sample rate와 channel에 맞게 조정 필요
        let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(self.count)) else { return nil }
        buffer.frameLength = AVAudioFrameCount(self.count)
        for i in 0..<self.count {
            buffer.floatChannelData?.pointee[i] = self[i]
        }
        return buffer
    }
}
