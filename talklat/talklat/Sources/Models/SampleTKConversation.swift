//
//  TKConversation.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/6/23.
//
import Foundation

struct TKConversation: Identifiable, Equatable, Hashable {
    let id: String /// 유니크함 지정
    var content: [TKContent]
    var location: TKLocation? // 위치정보를 켜지 않은경우 nil
    var title: String
    var createdAt: Date
    var updatedAt: Date
   
    struct TKContent: Identifiable, Equatable, Hashable {
        var id: String
        var text: String
        var status: MessageType.RawValue
        var createdAt: Date
    }
    
    struct TKLocation: Identifiable, Equatable, Hashable {
        var id: String
        var latitude: Double
        var longitude: Double
        var blockName: String
    }
}
