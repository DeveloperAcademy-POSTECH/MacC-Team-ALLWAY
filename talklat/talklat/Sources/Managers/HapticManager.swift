//
//  HapticManager.swift
//  talklat
//
//  Created by user on 2023/10/14.
//

import CoreHaptics
import SwiftUI

class HapticManager {
    enum HapticStyle: String {
        case sttToText
        case textToStt
    }
    
    static var sharedInstance: HapticManager = HapticManager()
    var engine: CHHapticEngine?
    
    init() {
        prepareHapticEngine()
    }
    
    /// hapticEngine을 준비하는 함수
    func prepareHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine?.stop()
            self.engine = try CHHapticEngine()
            self.engine?.playsHapticsOnly = true
            self.engine?.isAutoShutdownEnabled = true
            self.engine?.stoppedHandler = { reason in
                print("\(reason)")
            }
            self.engine?.resetHandler = {
                do {
                    print("reseting core haptic engine")
                    try self.engine?.start()
                } catch {
                    print("cannot reset core haptic engine")
                }
            }
        } catch {
            // 정상적으로 햅틱 엔진 시작 불가
            //            fatalError("Cannot create haptic engine")
            print("Cannot create haptic engine")
        }
    }
    
    /// 외부에서 Haptic에 접근하는 함수
    func generateHaptic(_ style: HapticStyle) {
        let pattern = self.generateHapticPattern(style)
        do {
            try self.playHaptic(pattern)
        } catch {
            print("Cannot play haptic")
        }
    }
    
    /// 햅틱 패턴을 만들어내는 함수
    private func generateHapticPattern(_ style: HapticStyle) -> CHHapticPattern? {
        switch style {
        // rigid twice
        case .sttToText:
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            
            
            let firstEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            let secondEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.1)
            
            let pattern = try? CHHapticPattern(events: [firstEvent, secondEvent], parameters: [])
            return pattern
            
        // success
        case .textToStt:
            let firstIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let firstSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.4)
            let firstEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [firstIntensity, firstSharpness], relativeTime: 0)
            
            let secondIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
            let secondSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            let secondEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [secondIntensity, secondSharpness], relativeTime: 0.15)
            
            let pattern = try? CHHapticPattern(events: [firstEvent, secondEvent], parameters: [])
            return pattern
            
        }
    }
    
    /// pattern에 따라 햅틱을 실행시키는 함수
    private func playHaptic(_ pattern: CHHapticPattern?) throws {
        // Generate haptic using the pattern above
        guard let givenPattern = pattern else { return }
        
        let player = try self.engine?.makePlayer(with: givenPattern)
        try player?.start(atTime: 0)
    }
}


// TestView for haptic
struct HapticTestView: View {
    var body: some View {
        VStack(spacing: 40) {
            Button("rigid 2번") {
                HapticManager.sharedInstance.generateHaptic(.sttToText)
            }
            
            Button("success") {
                HapticManager.sharedInstance.generateHaptic(.textToStt)
            }
        }
        .onAppear {
            HapticManager.sharedInstance.prepareHapticEngine()
        }
    }
}
