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
    @Relationship(deleteRule: .cascade) var location: TKLocation? // 위치정보를 켜지 않은경우 nil
    var title: String
    var createdAt: Date
    var updatedAt: Date
   
    
    init(
        id: String,
        title: String,
        createdAt: Date,
        updatedAt: Date,
        content: [TKContent]
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.content = content
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
    var blockName: String? // CLGeocoder가 주소를 찾지 못하거나 네트워크 연결이 되어있지 않을때 nil
    
    init(
        latitude: Double,
        longitude: Double
    ) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
