//
//  AudioUtilities.swift
//  SignalExtractionFromNoise
//
//  Created by Ye Eun Choi on 2023/10/11.
//  Copyright © 2023 Apple. All rights reserved.
//


import AVFoundation
import Accelerate

// The `AudioUtilities` structure provides a single function that returns an
// array of single-precision values from an audio resource.
// 단일 정밀도(single precision) - 32비트 부동 소수점 형식을 사용
struct AudioUtilities {
    static func getAudioSamples(
        forResource: String,
        withExtension: String
    ) async throws -> (
        naturalTimeScale: CMTimeScale,
        data: [Float]
    )? {
        guard let path = Bundle.main.url(
            forResource: forResource,
            withExtension: withExtension
        ) else {
            return nil
        }
        
        let asset = AVAsset(url: path.absoluteURL)
        let reader = try AVAssetReader(asset: asset)
        
        guard let track = try await asset.load(.tracks).first else {
            return nil
        }
        
        let outputSettings: [String: Int] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVNumberOfChannelsKey: 1,
            AVLinearPCMIsBigEndianKey: 0,
            AVLinearPCMIsFloatKey: 1,
            AVLinearPCMBitDepthKey: 32,
            AVLinearPCMIsNonInterleaved: 1
        ]
        
        let output = AVAssetReaderTrackOutput(track: track,
                                              outputSettings: outputSettings)
        
        reader.add(output)
        reader.startReading()
        
        var samplesData = [Float]()
        
        while reader.status == .reading {
            if
                let sampleBuffer = output.copyNextSampleBuffer(),
                let dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
                
                let bufferLength = CMBlockBufferGetDataLength(dataBuffer)
                let count = bufferLength / 4
                
                let data = [Float](unsafeUninitializedCapacity: count) {
                    buffer, initializedCount in
                    
                    CMBlockBufferCopyDataBytes(dataBuffer,
                                               atOffset: 0,
                                               dataLength: bufferLength,
                                               destination: buffer.baseAddress!)
                    
                    initializedCount = count
                }
                
                samplesData.append(contentsOf: data)
            }
        }
        
        let naturalTimeScale = try await track.load(.naturalTimeScale)
        
        return (naturalTimeScale: naturalTimeScale,
                data: samplesData)
    }
}
