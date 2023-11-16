//
//  TKLocation.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/11/23.
//

import Foundation
import SwiftData
import UIKit

@Model
final class TKLocation {
    var latitude: Double
    var longitude: Double
    var blockName: String
    var mapThumbnail: Data?
    var conversation: TKConversation?
    
    init(
        latitude: Double,
        longitude: Double,
        blockName: String,
        mapThumbnail: Data?
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.blockName = blockName
        self.mapThumbnail = mapThumbnail
    }
}
