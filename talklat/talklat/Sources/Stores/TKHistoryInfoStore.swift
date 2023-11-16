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
        if self(\.text).count >= 30 {
            self.reduce(\.text, into: String(self(\.text).prefix(30)))
            self.reduce(\.textLimitMessage, into: "30/30")
        } else if self(\.text).count == 0 {
            self.reduce(\.textLimitMessage, into: "한 글자 이상 입력해주세요.")
        } else {
            self.reduce(\.textLimitMessage, into: "\(self(\.text).count)/30")
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
