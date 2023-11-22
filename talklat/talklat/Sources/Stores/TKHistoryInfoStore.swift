//
//  TKHistoryInfoStore.swift
//  talklat
//
//  Created by user on 11/15/23.
//

import Foundation
import MapKit
import SwiftUI

class TKHistoryInfoStore: TKReducer {
    struct ViewState {
        var isShowingSheet: Bool = false
        var isShowingAlert: Bool = false
        var text: String = ""
        var textLimitMessage: String = ""
        var isNotChanged: Bool = true
        var infoCoordinateRegion: MKCoordinateRegion? = nil
        var editCoordinateRegion: MKCoordinateRegion? = nil
        var annotationItems: [CustomAnnotationInfo] = [CustomAnnotationInfo]()
        var isFlipped: Bool = false
    }
    
    @Published private var viewState = ViewState()
    
    public func bindingEditSheet() -> Binding<Bool> {
        Binding(
            get: { self(\.isShowingSheet) },
            set: { self.reduce(\.isShowingSheet, into: $0) }
        )
    }
    
    public func bindingShowingAlert() -> Binding<Bool> {
        Binding(
            get: { self(\.isShowingAlert) },
            set: { self.reduce(\.isShowingAlert, into: $0) }
        )
    }
    
    public func bindingText() -> Binding<String> {
        Binding(
            get: { self(\.text) },
            set: { self.reduce(\.text, into: $0) }
        )
    }
    
    public func bindingChangeStatus() -> Binding<Bool> {
        Binding(
            get: { self(\.isNotChanged) },
            set: { self.reduce(\.isNotChanged, into: $0) }
        )
    }
    
    public func bindingInfoCoordinate() -> Binding<MKCoordinateRegion> {
        Binding(
            get: {
                if let infoCoordinateRegion = self(\.infoCoordinateRegion) {
                    return infoCoordinateRegion
                } else {
                    return initialCoordinateRegion
                }
            },
            set: { self.reduce(
                \.infoCoordinateRegion,
                 into: $0
            )}
        )
    }
    
    public func bindingEditCoordinate() -> Binding<MKCoordinateRegion> {
        Binding(
            get: { guard let editCoordinateRegion = self(\.editCoordinateRegion) else {
                return initialCoordinateRegion
            }
                return editCoordinateRegion },
            set: { self.reduce(
                \.editCoordinateRegion,
                 into: $0
            ) }
        )
    }
    
    public func bindingFlipped() -> Binding<Bool> {
        Binding(
            get: { self(\.isFlipped) },
            set: { self.reduce(\.isFlipped, into: $0) }
        )
    }
    
    public func updateTextLimitMessage() {
        if self(\.text).count >= 20 {
            self.reduce(\.text, into: String(self(\.text).prefix(20)))
            self.reduce(\.textLimitMessage, into: "20/20")
        } else if self(\.text).count == 0 {
            self.reduce(\.textLimitMessage, into: "한 글자 이상 입력해주세요.")
        } else {
            self.reduce(\.textLimitMessage, into: "\(self(\.text).count)/20")
        }
    }
    
    public func saveButtonDisabled(_ conversation: TKConversation) -> Bool {
        let textStatus = self.hasTextChanged(conversation.title)
        let locationStatus = self.hasLocationChanged(conversation.location)
        
        guard textStatus != .textEmpty else { return true }
        
        // 총 4가지 경우가 있음
        // 1. text 안바뀜, location 안바뀜 -> 저장 x
        // 2. text 안바뀜, location 바뀜 -> 저장
        // 3. text 바뀜, location 안바뀜 -> 저장
        // 4. text 바뀜, location 바뀜 -> 저장
        if textStatus == .textNotChanged && locationStatus == .locationNotChanged {
            return true
        } else {
            return false
        }
    }
    
    private func hasTextChanged(_ title: String) -> HistoryInfoTextStatus {
        if title != self(\.text) {
            if self(\.text).isEmpty {
                return .textEmpty
            } else {
                return .textChanged
            }
        } else {
            return .textNotChanged
        }
    }
    
    private func hasLocationChanged(_ location: TKLocation?) -> HistoryInfoLocationStatus {
        // conversation location은 있음
        if let latitude = location?.latitude, let longitude = location?.longitude {
            let conversationCoordinate = CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
            
            // 근데 infoCoordinate가 없음
            guard let infoCoordinate = self(\.infoCoordinateRegion)?.center else { return .locationChanged }
            
            if conversationCoordinate != infoCoordinate {
                return .locationChanged
            } else {
                return .locationNotChanged
            }
        } else { // 만약 conversation.location은 nil인데
            if self(\.infoCoordinateRegion) != nil { // self(\.location이 있음)
                return .locationChanged
            } else { // 둘 다 nil
                return .locationNotChanged
            }
        }
    }
    
    func plantFlag(_ coordinate: MKCoordinateRegion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var newAnnotation = [CustomAnnotationInfo]()
            newAnnotation.append(CustomAnnotationInfo(
                name: "현재 위치",
                description: "설명",
                latitude: coordinate.center.latitude,
                longitude: coordinate.center.longitude
            ))
            
            self.reduce(\.annotationItems, into: newAnnotation)
        }
    }
    
    func callAsFunction<Value: Equatable> (_ path: KeyPath<ViewState, Value>) -> Value {
        self.viewState[keyPath: path]
    }
    
    func reduce<Value: Equatable>(_ path: WritableKeyPath<ViewState, Value>,
                                  into newValue: Value) {
        self.viewState[keyPath: path] = newValue
    }
}
