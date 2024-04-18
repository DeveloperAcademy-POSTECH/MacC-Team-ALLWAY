//
//  FirebaseActionable.swift
//  bisdam
//
//  Created by user on 4/6/24.
//

import Foundation

protocol FirebaseActionable: RawRepresentable where Self.RawValue == String {
    static var unRegistered: Self { get }
    
    static func create(_ eventName: String) -> Self
}

extension FirebaseActionable {
    static func create(_ eventName: String) -> Self {
        if let event = Self.init(rawValue: eventName) {
            return event
        } else {
            return .unRegistered
        }
    }
}
