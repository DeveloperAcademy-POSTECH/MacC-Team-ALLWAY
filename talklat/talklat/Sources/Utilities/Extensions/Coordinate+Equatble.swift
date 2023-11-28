//
//  Coordinate+Equatble.swift
//  bisdam
//
//  Created by user on 11/23/23.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        if lhs.center.latitude == rhs.center.latitude,
           lhs.center.longitude ==  rhs.center.longitude,
           lhs.span.latitudeDelta == rhs.span.latitudeDelta,
           lhs.span.longitudeDelta == rhs.span.longitudeDelta {
            return true
        } else {
            return false
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
