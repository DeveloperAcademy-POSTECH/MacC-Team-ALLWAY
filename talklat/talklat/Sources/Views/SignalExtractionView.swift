//
//  SignalExtractionView.swift
//  talklat
//
//  Created by Ye Eun Choi on 2023/10/15.
//

import SwiftUI
import Accelerate

struct SignalExtractionView: View {
    @EnvironmentObject var signalExtractor: SignalExtractor
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    Self.updatePath(path: &path,
                                    size: geometry.size,
                                    signal: signalExtractor.displayedWaveform,
                                    showFrequencyDomain: signalExtractor.showFrequencyDomain)
                }
                .stroke(signalExtractor.showFrequencyDomain ? .blue : .red,
                        lineWidth: 3)
                .clipped()
            }
            
            HStack {
                Text("threshold")
                Slider(
                    value: $signalExtractor.threshold,
                    in: 0...256
                ) {
                    Text("Threshold")
                }
                
                Spacer(minLength: 100)
                
                Slider(
                    value: $signalExtractor.noiseAmount,
                    in: 0...4
                ) {
                    Text("Noise Amount")
                }
                
                Spacer(minLength: 100)
                
                Toggle("Show frequency domain",
                       isOn: $signalExtractor.showFrequencyDomain)
            }
        }
        .padding()
    }
    
    static func updatePath(path: inout Path,
                           size: CGSize,
                           signal: [Float],
                           showFrequencyDomain: Bool) {

        let count = showFrequencyDomain ? signal.count / 8 : signal.count
        
        let minimum: Float = vDSP.minimum(signal[0 ..< count])
        let maximum: Float = vDSP.maximum(signal[0 ..< count])

        let scale = 1 / (maximum - minimum)
        let minusMin = [Float](repeating: -minimum, count: count)
        let scaled = vDSP.multiply(addition: (signal[0 ..< count], minusMin), scale)
        
        let xScale = size.width / CGFloat(count)
        let points = scaled.enumerated().map {
            return CGPoint(x: xScale * CGFloat($0.offset),
                           y: size.height * CGFloat(1.0 - $0.element))
        }
        
        let cgPath = CGMutablePath()
        cgPath.addLines(between: points)
        
        path = Path(cgPath)
    }
}

