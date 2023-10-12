//
//  GyroScopeManager.swift
//  talklat
//
//  Created by user on 2023/10/05.
//

import CoreMotion
import Foundation
import SwiftUI

enum FlippedStatus: String {
    case opponent
    case myself
}

class GyroScopeStore: ObservableObject {
    
    @Published var faced: FlippedStatus = .myself
    private var rotationDegree: Double = 0.0
    
    let motionManager: CMMotionManager
    let timeInterval: Double
    let queue: OperationQueue = OperationQueue()
    
    init() {
        motionManager = CMMotionManager()
        timeInterval = 1.0 / 60.0
    }
    
    // MARK: Motion을 감지할때 사용하는 메서드
    // 다른 queue에서 motion을 감지합니다.
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = timeInterval
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(
                using: .xArbitraryCorrectedZVertical,
                to: queue
            ) { (data, error) in
                if let validData = data {
                    // MARK: roll, pitch, yaw를 전부 사용해서 attitude를 판단
                    self.rotationDegree = abs(validData.attitude.pitch.toDegrees()) + abs(validData.attitude.roll.toDegrees()) + abs(validData.attitude.yaw.toDegrees())
                    
                    // 실제 뷰에서 사용하는 부분은 Main Queue에서 업데이트
                    DispatchQueue.main.async {
                        self.faced = {
                            switch self.rotationDegree {
                            case ...150:
                                return FlippedStatus.myself
                            case 151...300:
                                return FlippedStatus.opponent
                            default:
                                return FlippedStatus.myself
                            }
                        }()
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
    func stopMotionManager() {
        self.motionManager.stopDeviceMotionUpdates()
    }
}

extension Double {
    func toDegrees() -> Double {
        return 180 / Double.pi * self
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
            gyroStore.startDeviceMotion()
        }
    }
}
