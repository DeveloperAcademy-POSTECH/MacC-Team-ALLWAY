/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Signal extractor from noise class.
*/

import Accelerate
import Combine
import AVFAudio

/// A class that provides a drum loop and exposes properties to apply audio equalization.
class SignalExtractor: ObservableObject {
    static let sampleCount = 1024
    
    static let forwardDCTSetup = vDSP.DCT(count: sampleCount,
                                   transformType: vDSP.DCTTransformType.II)!
    
    static let inverseDCTSetup = vDSP.DCT(count: sampleCount,
                                   transformType: vDSP.DCTTransformType.III)!
    
    /// An array that contains the samples for the entire audio resource.
    public var samples = [Float]()
    
    /// The current page of `sampleCount` elements in `samples`.
    private var pageNumber = 0
    
    /// The sample rate of the drum loop sample.
    public var sampleRate = Int32(0)
    
    private var noisySignal: [Float]
    
    private var timeDomainSignal = [Float](
        repeating: 0,
        count: sampleCount
    )
    
    private var frequencyDomainSignal = [Float](
        repeating: 0,
        count: sampleCount
    )
    
    @Published var displayedWaveform = [Float](
        repeating: 0,
        count: sampleCount
    )
    
    @Published var threshold = Double(0) {
        didSet {
            displaySignalFromNoise()
        }
    }
    
    @Published var noiseAmount: Double = 0 {
        didSet {
            noisySignal = samples
            displaySignalFromNoise()
        }
    }
    
    @Published var showFrequencyDomain = false {
        didSet {
            displayedWaveform = showFrequencyDomain ? frequencyDomainSignal : timeDomainSignal
        }
    }
    
    init() {
        noisySignal = samples
        displaySignalFromNoise()
    }
    
    func loadAudioSamples() async throws {
        guard let samples = try await AudioUtilities.getAudioSamples(
            forResource: "Rhythm",
            withExtension: "aif") else {
            fatalError("Unable to parse the audio resource.")
        }
        
        self.samples = samples.data
        self.sampleRate = samples.naturalTimeScale
    }
}

extension SignalExtractor {
    func displaySignalFromNoise() {
        Self.extractSignalFromNoise(
            noisySignal: noisySignal,
            threshold: threshold,
            timeDomainDestination: &timeDomainSignal,
            frequencyDomainDestination: &frequencyDomainSignal
        )
        
        displayedWaveform = showFrequencyDomain ? frequencyDomainSignal : timeDomainSignal
    }
    
    static func extractSignalFromNoise(
        noisySignal: [Float],
        threshold: Double,
        timeDomainDestination: inout [Float],
        frequencyDomainDestination: inout [Float]
    ) {
        
        forwardDCTSetup.transform(noisySignal,
                                  result: &frequencyDomainDestination)
        
        vDSP.threshold(frequencyDomainDestination,
                       to: Float(threshold),
                       with: .zeroFill,
                       result: &frequencyDomainDestination)
        
        
        inverseDCTSetup.transform(frequencyDomainDestination,
                                  result: &timeDomainDestination)
        
        
        let divisor = Float(Self.sampleCount / 2)
        
        vDSP.divide(timeDomainDestination,
                    divisor,
                    result: &timeDomainDestination)
        
    }
}

extension SignalExtractor: SignalProvider {
    //
}
