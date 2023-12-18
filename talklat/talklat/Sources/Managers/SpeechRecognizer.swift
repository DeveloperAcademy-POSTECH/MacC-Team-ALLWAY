//
//  SpeechRecognizer.swift
//  talklat
//
//  Created by 신정연 on 2023/10/05.
//

import Accelerate
import AVFoundation
import Combine
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
    
    public var cancellableSet = Set<AnyCancellable>()
    public var currentTranscript = CurrentValueSubject<String, Never>("")
    
    private var recognizer: SFSpeechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var audioEngine: AVAudioEngine = AVAudioEngine()
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    private var audioBuffers: [AVAudioPCMBuffer] = []
    private let signalExtractor = SignalExtractor()
    
    init() {
        initRecognizer()
        initAudioSession()
    }
    
    private func initRecognizer() {
        recognizer.defaultTaskHint = .unspecified
        recognizer.supportsOnDeviceRecognition = false
    }
    
    private func initAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setAllowHapticsAndSystemSoundsDuringRecording(true)
            try audioSession.setCategory(
                .playAndRecord,
                mode: .measurement,
                options: .defaultToSpeaker
            )
            try audioSession.setActive(
                true,
                options: .notifyOthersOnDeactivation
            )
            
        } catch {
            self.stopAndResetTranscribe()
            self.transcribeFailed(error)
        }
    }
    
    public func startTranscribing() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.beginTranscribe()
        }
    }
    
    public func stopAndResetTranscribing() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.stopAndResetTranscribe()
        }
    }
    
    private func prepareSpeechRequest() -> SFSpeechAudioBufferRecognitionRequest? {
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else { return nil }
        
        request.addsPunctuation = true
        request.shouldReportPartialResults = true
        return request
    }
    
    private func prepareInputNode() -> AVAudioInputNode {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request?.append(buffer)
        }
        
        return inputNode
    }
    
    private func startAudioEngine() {
        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            self.stopAndResetTranscribe()
            self.transcribeFailed(error)
        }
    }
    
    // text 전환을 시작합니다.
    private func beginTranscribe() {
        stopAndResetTranscribe()
        guard recognizer.isAvailable else {
            self.transcribeFailed(RecognizerError.recognizerIsUnavailable)
            return
        }
        
        guard let request = prepareSpeechRequest() else { return }

        let inputNode = prepareInputNode()
        startAudioEngine()

        task = recognizer.recognitionTask(with: request) { result, error in
            guard let result else { return }
            self.recognitionTaskHandler(
                result: result,
                error: error,
                inputNode: inputNode
            )
        }
    }
    
    private func recognitionTaskHandler(
        result: SFSpeechRecognitionResult,
        error: Error?,
        inputNode: AVAudioInputNode
    ) {
        var isFinal = false
        self.transcribe(result.bestTranscription.formattedString)
        isFinal = result.isFinal
        
        if error != nil || isFinal {
            self.audioEngine.stop()
            inputNode.removeTap(onBus: 0)
            
            self.request = nil
            self.task = nil
        }
    }
    
    private func stopAndResetTranscribe() {
        request?.endAudio()
        task?.cancel()
        self.request = nil
        self.task = nil
        currentTranscript.value.removeAll(keepingCapacity: true)
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
        
    private func addPunctuation(_ transcript: String) -> String {
        var modifiedTranscript = transcript
        var searchStartIndex = modifiedTranscript.startIndex
        
        for pattern in ConversationPatterns.questionPatterns {
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
        Task { @MainActor [weak self] in
            guard let self else { return }
            currentTranscript.value = addPunctuation(message)
        }
    }
    
    nonisolated private func transcribeFailed(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
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
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: AVAudioFrameCount(self.count)
        ) else { return nil }
        
        buffer.frameLength = AVAudioFrameCount(self.count)
        for i in 0..<self.count {
            buffer.floatChannelData?.pointee[i] = self[i]
        }
        
        return buffer
    }
}

extension SpeechRecognizer {
    // 음성 인식 정확도를 측정하는 함수1
    private func levenshteinDistanceBetween(
        _ a: String,
        and b: String
    ) -> Int {
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
    private func calculateRecognitionAccuracy(
        originalText: String,
        recognizedText: String
    ) -> Double {
        let distance = levenshteinDistanceBetween(originalText, and: recognizedText)
        let maxLength = max(originalText.count, recognizedText.count)
        
        let accuracy = ((Double(maxLength) - Double(distance)) / Double(maxLength)) * 100.0
        return accuracy
    }
    
    enum EngineError: Error {
        case NoRequestAvailble
    }
}
