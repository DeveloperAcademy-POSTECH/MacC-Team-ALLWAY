//
//  TKConversation.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/6/23.
//
import Foundation
import SwiftData

@Model
class TKConversation {
    @Attribute(.unique) var id: String /// 유니크함 지정
    @Relationship(deleteRule: .cascade) var content: [TKContent]
    @Relationship(deleteRule: .cascade) var location: TKLocation
    var title: String
    var createdAt: Date
    var updatedAt: Date
   
    
    init(
        id: String,
        title: String,
        createdAt: Date,
        updatedAt: Date,
        content: [TKContent],
        location: TKLocation
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.content = content
        self.location = location
    }
}

@Model
class TKContent {
    var text: String
    var status: MessageType.RawValue
    var createdAt: Date
    
    init(
        text: String,
        status: MessageType.RawValue,
        createdAt: Date
    ) {
        self.text = text
        self.status = status
        self.createdAt = createdAt
    }
}

@Model
class TKLocation {
    var latitude: Double
    var longitude: Double
    var blockName: String
    
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
