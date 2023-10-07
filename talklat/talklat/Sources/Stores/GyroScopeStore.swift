//
//  GyroScopeManager.swift
//  talklat
//
//  Created by user on 2023/10/05.
//

import CoreMotion
import Foundation

enum FlippedStatus: String {
    case opponent
    case myself
}

class GyroScopeStore: ObservableObject {
    
    @Published var faced: FlippedStatus = .myself
    @Published var yaw: Double = 0.0
    
    let motionManager: CMMotionManager
    let timeInterval: Double
    
    init() {
        motionManager = CMMotionManager()
        timeInterval = 1.0 / 60.0
    }
    
    // Mark: Motion을 감지할때 사용하는 메서드
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = timeInterval
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(
                using: .xArbitraryCorrectedZVertical,
                to: .main
            ) { (data, error) in
                if let validData = data {
                    // 실제 coreMotion의 3가지 attitude 중 yaw로 flip 이벤트 측정
                    let yaw = abs(validData.attitude.yaw.toDegrees())
                    self.yaw = yaw
                    
                    self.faced = {
                        switch yaw {
                        case ...90:
                            return FlippedStatus.myself
                        case 91...:
                            return FlippedStatus.opponent
                        default:
                            return FlippedStatus.myself
                        }
                    }()
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
