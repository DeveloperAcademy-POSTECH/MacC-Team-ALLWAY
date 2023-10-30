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
            //weak self 추가
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
    
    // 오디어 데이터 처리 메서드 추가 -> Maybe 리앤 코드로 대체
    public func processAudioDate() {
        for buffer in audioBuffers {
            //signalextractor
            let processedData = signalExtractor.process(buffer: buffer)
            // TODO: 데이터 처리 및 저장 하는 코드 추가 해야함
            // 노이즈가 제거된 오디오 데이터를 SFSpeechAudioBufferRecognitionRequest 객체에 추가
            if let processedDataBuffer = processedData.toBuffer() {
                self.request?.append(processedDataBuffer)
            } else {
                print("Error: Failed to convert processed data to buffer")
            }
        }
        // 처리 다 하고 audioBuffer 비우기
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
            transcribe(recognizedText)
        } else if let error = error {
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
