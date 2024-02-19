//
//  SignalExtractor.swift
//  talklat
//
//  Created by 신정연 on 2023/10/11.
//

import Foundation
import Accelerate
import AVFAudio

struct SignalExtractor {
    
    static let sampleCount = 1024
    
    static let forwardDCTSetup = vDSP.DCT(count: sampleCount,
                                          transformType: vDSP.DCTTransformType.II)!
    
    static let inverseDCTSetup = vDSP.DCT(count: sampleCount,
                                          transformType: vDSP.DCTTransformType.III)!
    
    func process(buffer: AVAudioPCMBuffer) -> [Float] {
        
        // buffer에서 데이터 가져오기
        let bufferLength = min(buffer.frameLength, AVAudioFrameCount(SignalExtractor.sampleCount))
        var noisySignal: [Float] = Array(repeating: 0, count: SignalExtractor.sampleCount)
        let bufferPointer = buffer.floatChannelData?.pointee
        for i in 0..<Int(bufferLength) {
            noisySignal[i] = bufferPointer![i]
        }

        var timeDomainSignal = [Float](repeating: 0, count: SignalExtractor.sampleCount)
        var frequencyDomainSignal = [Float](repeating: 0, count: SignalExtractor.sampleCount)

        // 주파수 영역으로 변환
        SignalExtractor.forwardDCTSetup.transform(noisySignal, result: &frequencyDomainSignal)
        
        // 임계값보다 낮은 주파수 값을 0으로 설정하여 노이즈 제거
        let threshold: Float = 0.5
        vDSP.threshold(frequencyDomainSignal, to: threshold, with: .zeroFill, result: &frequencyDomainSignal)
        
        // 시간 영역으로 다시 변환
        SignalExtractor.inverseDCTSetup.transform(frequencyDomainSignal, result: &timeDomainSignal)
        
        let divisor = Float(SignalExtractor.sampleCount / 2)
        vDSP.divide(timeDomainSignal, divisor, result: &timeDomainSignal)
        
        return timeDomainSignal
    }
}

// 라이브 음성 처리
#warning("사용하지 않는 class")
class LiveAudioProcessor {
    let audioEngine = AVAudioEngine()
    var audioBuffers: [AVAudioPCMBuffer] = []
    let signalExtractor = SignalExtractor()

    func startProcessing() {
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        let bufferSize = AVAudioFrameCount(SignalExtractor.sampleCount)
        
        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: format) { [weak self] (buffer, time) in
            self?.audioBuffers.append(buffer)
            self?.processAudioDate()
        }
        
        try? audioEngine.start()
    }
    
    func stopProcessing() {
        audioEngine.stop()
    }

    func processAudioDate() {
        for buffer in audioBuffers {
            let processedData = signalExtractor.process(buffer: buffer)
            // TODO: 필요에 따라 processedData를 사용하여 추가 작업 수행
        }
        audioBuffers.removeAll()
    }
}
