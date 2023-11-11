//
//  ConversationDataManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/6/23.
//

import SwiftData
import SwiftUI

final class ConversationDataManager: ObservableObject {
    @Environment(\.modelContext) private var context
    
    // MARK: - CREATE
    public func createConversation(_ conversation: TKConversation) {
        context.insert(conversation)
    }
    
    // MARK: - UPDATE
    public func updateConversation(
        oldItem: TKConversation,
        newItem: TKConversation
    ) {
        oldItem.title = newItem.title
        oldItem.createdAt = newItem.createdAt
        oldItem.updatedAt = newItem.updatedAt
        oldItem.content = newItem.content
    }
    
    // MARK: - DELETE
    public func deleteConversation(_ conversation: TKConversation) {
        context.delete(conversation)
    }
}

extension ModelContext {
    // MARK: - FETCH
    // Model ID와 일치하는 단일 인스턴스 반환
    public func fetchMatchingObject<T>(
        for objectID: PersistentIdentifier
    ) throws -> T? where T: PersistentModel {
        if let registered: T = registeredModel(for: objectID) {
            return registered
        }
        
        let fetchDescriptor = FetchDescriptor<T>(
            predicate: #Predicate {
                $0.persistentModelID == objectID
            }
        )
        
        return try fetch(fetchDescriptor).first
    }
    
    // 해당 Model 타입의 모든 인스턴스 반환
    public func fetchAllMatchingObjects<T>(
        for object: T
    ) throws -> [T]? where T: PersistentModel {
        let fetchDescriptor = FetchDescriptor<T>()
        
        return try fetch(fetchDescriptor)
    }
}




