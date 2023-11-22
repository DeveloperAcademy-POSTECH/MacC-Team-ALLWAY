//
//  TKConversation.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/6/23.
//
import Foundation
import SwiftData

@Model
final class TKConversation {
    var title: String
    var createdAt: Date
    var updatedAt: Date?
    
    @Relationship(deleteRule: .cascade, inverse: \TKContent.conversation)
    var content: [TKContent] = [TKContent]()
    
    @Relationship(deleteRule: .cascade, inverse: \TKLocation.conversation)
    var location: TKLocation?
    
    var formattedCreatedAt: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd. HH:mm"
        return dateFormatter.string(from: self.createdAt)
    }
    
    init(
        title: String,
        createdAt: Date,
        content: [TKContent],
        location: TKLocation? = nil
    ) {
        self.title = title
        self.createdAt = createdAt
        self.content = content
        self.location = location
    }
}
