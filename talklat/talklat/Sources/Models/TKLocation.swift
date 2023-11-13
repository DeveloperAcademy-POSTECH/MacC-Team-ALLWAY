//
//  TKLocation.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/11/23.
//

import Foundation
import SwiftData

@Model
final class TKLocation {
    var latitude: Double
    var longitude: Double
    var blockName: String
    var conversation: TKConversation?
    
    init(
        latitude: Double,
        longitude: Double,
        blockName: String
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.blockName = blockName
    }
}
