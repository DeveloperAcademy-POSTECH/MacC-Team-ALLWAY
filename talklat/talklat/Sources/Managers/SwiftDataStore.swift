//
//  SwiftDataManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/8/23.
//

import SwiftUI
import SwiftData

@Observable
final class SwiftDataStore {
    @ObservationIgnored
    private let dataManager: TKDataManager
    
    var conversations: [TKConversation] = []
    var contents: [TKContent] = []
    var locations: [TKLocation] = []
    var textReplacements: [TKTextReplacement] = []
    
    init(dataSource: TKDataManager = TKDataManager.shared) {
        self.dataManager = dataSource
        refreshData()
    }
    
    private func refreshData() {
        do {
            conversations = try dataManager.fetchItems(TKConversation.self) ?? []
            contents = try dataManager.fetchItems(TKContent.self) ?? []
            locations = try dataManager.fetchItems(TKLocation.self) ?? []
            textReplacements = try dataManager.fetchItems(TKTextReplacement.self) ?? []
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func appendItem(_ item: any PersistentModel) {
        dataManager.appendItem(item)
        refreshData()
    }
    
    public func removeItem(_ item: any PersistentModel) {
        dataManager.removeItem(item)
        refreshData()
    }

//    public func updateItem(_ item: ) {
//    }
}

// MARK: - Additional Methods
extension SwiftDataStore {
    // 
}


