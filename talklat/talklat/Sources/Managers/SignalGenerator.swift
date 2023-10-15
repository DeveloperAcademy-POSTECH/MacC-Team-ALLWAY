//
//  SignalGenerator.swift
//  SignalExtractionFromNoise
//
//  Created by Ye Eun Choi on 2023/10/11.
//  Copyright © 2023 Apple. All rights reserved.
//

import AVFoundation
import Accelerate

// The `SignalGenerator` class renders the signal that a `SignalProvider` instance provides as audio.
class SignalGenerator {
    private let sampleRate: CMTimeScale
    
    private let engine = AVAudioEngine()
    private let signalProvider: SignalProvider
    private var page = [Float]()
    
    private lazy var format = AVAudioFormat(
        standardFormatWithSampleRate: Double(sampleRate),
        channels: 1
    )
    
    private lazy var sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
        let audioBufferListPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        
        if self.engine.mainMixerNode.outputVolume <= 0.5 {
            self.engine.mainMixerNode.outputVolume += 0.1 * self.engine.mainMixerNode.outputVolume
        }
        
        for frame in 0..<Int(frameCount) {
            let value = self.getSignalElement()
            
            for buffer in audioBufferListPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = value
            }
        }
        return noErr
    }
    
    init(signalProvider: SignalProvider) {
        self.signalProvider = signalProvider
        self.sampleRate = signalProvider.sampleRate
        
        engine.attach(sourceNode)
        
        engine.connect(
            sourceNode,
            to: engine.mainMixerNode,
            format: format
        )
        
        engine.connect(
            engine.mainMixerNode,
            to: engine.outputNode,
            format: format
        )
        
        engine.mainMixerNode.outputVolume = 0
        engine.prepare()
    }
    
    public func start() throws {
        engine.mainMixerNode.outputVolume = 1e-4
        try engine.start()
    }
    
    private func getSignalElement() -> Float {
        return page.isEmpty ? 0 : page.removeFirst()
    }
    
    deinit {
        engine.stop()
    }
}

protocol SignalProvider {
    var sampleRate: CMTimeScale { get }
}
