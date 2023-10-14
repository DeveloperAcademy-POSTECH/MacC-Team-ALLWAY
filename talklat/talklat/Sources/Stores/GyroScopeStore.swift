//
//  GyroScopeManager.swift
//  talklat
//
//  Created by user on 2023/10/05.
//

import CoreMotion
import CoreHaptics
import Foundation
import SwiftUI

final class GyroScopeStore: ObservableObject {
    @Published private(set) var faced: FlippedStatus = .myself
    
    private var rotationDegree: Double = 0.0
    private let motionManager: CMMotionManager
    private let timeInterval: Double
    private let gyroScopeQueue: OperationQueue = OperationQueue()

    
    // MARK: INIT
    init() {
        motionManager = CMMotionManager()
        timeInterval = 1.0 / 60.0
    }
    
    // MARK: Motion을 감지할때 사용하는 메서드
    // 다른 queue에서 motion을 감지합니다.
    public func detectDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = timeInterval
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(
                using: .xArbitraryCorrectedZVertical,
                to: gyroScopeQueue
            ) { [weak self] (data, error) in
                if let validData = data {
                    // MARK: roll, pitch, yaw를 전부 사용해서 attitude를 판단
                    self?.rotationDegree = abs(validData.attitude.pitch.toDegrees()) + abs(validData.attitude.roll.toDegrees()) + abs(validData.attitude.yaw.toDegrees())
                    
                    // 실제 뷰의 UI를 변경하는 부분은 Main Queue에서 업데이트
                    DispatchQueue.main.async {
                        self?.faced = self?.motionStatusSetter(self?.rotationDegree) ?? .myself
                    }
                }
            }
        } else {
            // device에서 core motion을 지원 안할때
            // 근데 iOS 4.0 이상 전부 지원하니까 괜찮지 않을까 하는 생각
            fatalError("기기가 CoreMotion을 지원 안함")
            
        }
    }
    
    // Mark: MotionManger를 멈출때 쓰는 메서드
    public func stopMotionManager() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    private func motionStatusSetter(_ rotationDegree: Double?) -> FlippedStatus? {
        guard let degree = rotationDegree else { return nil }
        switch degree {
        case ...150:
            return FlippedStatus.myself
        case 151...300:
            return FlippedStatus.opponent
        default:
            return FlippedStatus.myself
        }
    }
}


// Rotation을 테스트하기 위한 앱
struct RotationTestView: View {
    @StateObject private var gyroStore: GyroScopeStore = GyroScopeStore()
    
    var body: some View {
        VStack {
            Text(gyroStore.faced.rawValue)
//            Text("\(gyroStore.rotationDegree)")
        }
        .onAppear {
            gyroStore.detectDeviceMotion()
        }
    }
}
