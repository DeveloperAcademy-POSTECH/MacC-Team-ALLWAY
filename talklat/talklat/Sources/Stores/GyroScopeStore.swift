//
//  GyroScopeManager.swift
//  talklat
//
//  Created by user on 2023/10/05.
//

import CoreMotion
import Foundation
import SwiftUI

final class GyroScopeStore: ObservableObject {
    @Published private(set) var faced: FlippedStatus = .myself
    
    private(set) var standardDegree: Double = 0.0
    private(set) var rotationDegree: Double = 0.0
    private var coreMotionManager: CMMotionManager?
    private let timeInterval: Double
    private let gyroScopeQueue: OperationQueue = OperationQueue()
    private let writingDegreeLimit: Double = 130
    private let recordingDegreeLimit: Double = 170
    
    ///initialzier
    init() {
        coreMotionManager = CMMotionManager()
        timeInterval = 1.0 / 10.0
    }
    
    ///CoreMotion을 감지할때 사용하는 메서드
    public func detectDeviceMotion() {
        guard let motionManager = coreMotionManager else { return }
        
        //MARK: 이 작업은 다른 queue에서 진행됨. UI업데이트만 Main Qeueue에서 진행
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = timeInterval
            motionManager.showsDeviceMovementDisplay = true
            motionManager.startDeviceMotionUpdates(
                using: .xArbitraryCorrectedZVertical,
                to: gyroScopeQueue
            ) { [weak self] (data, error) in
                if let validData = data {
                    // MARK: roll, pitch, yaw를 전부 사용해서 attitude를 판단
                    self?.rotationDegree = abs(validData.attitude.pitch.toDegrees()) + abs(validData.attitude.roll.toDegrees()) + abs(validData.attitude.yaw.toDegrees())
                    
                    //y축 각속도가 2 이상일때
                    if abs(validData.rotationRate.y) > 2 {
                        //MARK: 실제 뷰의 UI를 변경하는 부분은 Main Queue에서 업데이트
                        DispatchQueue.main.async {
                            self?.faced = self?.motionStatusSetter(self?.rotationDegree) ?? .myself
                        }
                    }
                }
            }
        } else {
            // device에서 core motion을 지원 안할때
            // 근데 iOS 4.0 이상 전부 지원하니까 괜찮지 않을까 하는 생각
            //            fatalError("기기가 CoreMotion을 지원 안함")
            
        }
    }
    
    ///MotionManger를 멈출때 쓰는 메서드
    public func stopMotionManager() {
        guard let motionManager = self.coreMotionManager else { return }
        motionManager.stopDeviceMotionUpdates()
    }
    
    ///화면의 방향 및 모션에 따라 faced status를 설정하는 메서드
    private func motionStatusSetter(_ rotationDegree: Double?) -> FlippedStatus? {
        guard let degree = rotationDegree else { return nil }
        
        let degreeDifference: Double = abs(degree - standardDegree)
        let degreeArea: DegreeArea = checkArea(degree)
        
        // 새 값이 중립지역에서 관측되면 기준을 옮기지도 않고, 상태변화도 없음
        guard degreeArea != .neutralArea else {
            return self.faced
        }
        
        // 값이 너무 튈때(내가 화면을 보다가 눕힐때) 상태변화를 잡기 위한 guard
        guard degreeDifference < 200 else {
            return self.faced
        }
        
        // 새로 관측된 지점이 중립지역이 아니니까 기준값을 새로 옮김
        self.standardDegree = degree
        
        // 세팅할 화면을 정하는 기준
        if degreeDifference < 40 { // 두 각의 차이가 40 이하
            return self.faced
        } else { // 두 각의 차이가 40도 이상
            switch degreeArea { // 새로운 각값에 따라 화면이 보는 방향이 결정됨
            case .writingArea:
                return .myself
            case .recordingArea:
                return .opponent
            default:
                return self.faced
            }
        }
    }
    
    /// 화면이 어느 영역(myself, neutral, opponent) 중 어느 영역에 있는지 확인하는 함수
    private func checkArea(_ degree: Double) -> DegreeArea {
        switch degree {
        case ...writingDegreeLimit:
            return .writingArea
        case (writingDegreeLimit+1)...recordingDegreeLimit:
            return .neutralArea
        default:
            return .recordingArea
        }
    }
    
    //사용자가 수동으로 motionManager를 재설정 가능한 함수
    public func reinitialzie() {
        self.coreMotionManager = nil
        self.coreMotionManager = CMMotionManager()
        self.detectDeviceMotion()
    }
}


// Rotation을 테스트하기 위한 앱
struct RotationTestView: View {
    @StateObject private var gyroStore: GyroScopeStore = GyroScopeStore()
    
    var body: some View {
        VStack {
            Text(gyroStore.faced.rawValue)
        }
        .onAppear {
            gyroStore.detectDeviceMotion()
        }
    }
}
