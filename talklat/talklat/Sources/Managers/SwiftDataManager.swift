//
//  SwiftDataManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/8/23.
//

import SwiftUI
import SwiftData

@Observable
final class SwiftDataManager {
    @ObservationIgnored
    private let dataSource: TKDataSource
    
    var conversations: [TKConversation] = []
    var contents: [TKContent] = []
    var locations: [TKLocation] = []
    var textReplacements: [TKTextReplacement] = []
    
    init(dataSource: TKDataSource = TKDataSource.shared) {
        self.dataSource = dataSource
        refreshData()
    }
    
    private func refreshData() {
        do {
            conversations = try dataSource.fetchItems(TKConversation.self) ?? []
            contents = try dataSource.fetchItems(TKContent.self) ?? []
            locations = try dataSource.fetchItems(TKLocation.self) ?? []
            textReplacements = try dataSource.fetchItems(TKTextReplacement.self) ?? []
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public func appendItem(_ item: any PersistentModel) {
        dataSource.appendItem(item)
        refreshData()
    }
    
    public func removeItem(_ item: any PersistentModel) {
        dataSource.removeItem(item)
        refreshData()
    }

//    public func updateItem(_ item: ) {
//    }
}



