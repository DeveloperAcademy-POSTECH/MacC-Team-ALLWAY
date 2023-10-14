//
//  SignalExtractor.swift
//  talklat
//
//  Created by 신정연 on 2023/10/11.
//

import Foundation
import Accelerate
import AVFAudio

class SignalExtractor {
    
    static let sampleCount = 1024
    
    static let forwardDCTSetup = vDSP.DCT(count: sampleCount,
                                          transformType: vDSP.DCTTransformType.II)!
    
    static let inverseDCTSetup = vDSP.DCT(count: sampleCount,
                                          transformType: vDSP.DCTTransformType.III)!
    
    func process(buffer: AVAudioPCMBuffer) -> [Float] {
        
        // TODO: buffer에서 noisySignal로 데이터 변환하는 로직 필요
        // 1. 오디오 데이터를 가져옴 (이 부분은 이미 `buffer`로 제공됨)
        var noisySignal: [Float] = Array(repeating: 0, count: Self.sampleCount)
        
        var timeDomainSignal = [Float](repeating: 0,
                                       count: Self.sampleCount)
        var frequencyDomainSignal = [Float](repeating: 0,
                                            count: Self.sampleCount)

        // 2. 주파수 영역으로 변환
        Self.forwardDCTSetup.transform(noisySignal, result: &frequencyDomainSignal)
        
        // TODO: test하면서 임계값 조정 (sample: 0...256)
        // 3. 임계값보다 낮은 주파수 값을 0으로 설정하여 노이즈를 제거
        let threshold: Float = 0.5
        
        // TODO: 적절한 임계값 설정이 필요함
        vDSP.threshold(frequencyDomainSignal, to: threshold, with: .zeroFill, result: &frequencyDomainSignal)
        
        // 4. 시간 영역으로 다시 변환
        Self.inverseDCTSetup.transform(frequencyDomainSignal, result: &timeDomainSignal)
        
        let divisor = Float(Self.sampleCount / 2)
        vDSP.divide(timeDomainSignal, divisor, result: &timeDomainSignal)
        
        return timeDomainSignal
    }
}
