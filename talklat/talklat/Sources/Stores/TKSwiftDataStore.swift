//
//  SwiftDataManager.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/8/23.
//

import SwiftUI
import SwiftData

@Observable
final class TKSwiftDataStore {
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
extension TKSwiftDataStore {
    // HistoryListView에서 쓰이는 specific fetch (TKLocation -> TKConversation)
    public func getLocationBasedConversations(location: TKLocation) -> [TKConversation] {
        let conversations = dataManager.getLocationMatchingConversations(location: location)
        return conversations
    }
    
    // HistoryListSearchView에서 쓰이는 specific fetch (TKContent -> TKLocation)
    public func getContentBasedLocations(contents: [TKContent]) -> [TKLocation] {
        var locations: [TKLocation] = []
        contents.forEach { content in
            locations = dataManager.getContentMatchingLocations(content: content)
        }
        return filterDuplicatedBlockNames(locations: locations)
    }
    
    // 중복되는 blockName을 제거한 [TKLocation]
    public func filterDuplicatedBlockNames(locations: [TKLocation]) -> [TKLocation] {
        let groupedLocations = Dictionary(grouping: locations, by: { $0.blockName })
        let uniqueLocations = groupedLocations.compactMap { $0.value.first }
        return uniqueLocations
    }
    
    public func getRecentConversation() -> TKConversation? {
        refreshData()
        return conversations.sorted { $0.createdAt > $1.createdAt }.first
    }
    
    public func getAllConversation() -> [TKConversation] {
        dataManager.getAllConversations()
    }
    
    // HistoryListSearchView에서 쓰이는 specific fetch (TKContent -> TKConversation)
//    public func getContentBasedConversations(content: [TKContent]) -> [TKConversation] {
//        var conversations: [TKConversation] = []
//        contents.forEach { content in
//            conversations = dataManager.getContentMatchingConversations(content: content)
//        }
//        return conversations
//    }
}

// MARK: TextReplacement Related
extension TKSwiftDataStore {
    
    // MARK: 기본 Create
    public func createTextReplacement(phrase: String, replacement: String) {
        let newTextReplacement = TKTextReplacement(wordDictionary: [phrase: [replacement]])
        dataManager.appendItem(newTextReplacement)
        refreshData()
    }

    public func updateTextReplacement(
        oldTextReplacement: TKTextReplacement,
        newPhrase: String,
        newReplacement: String
    ) {
        print(#function, newPhrase, newReplacement)
        oldTextReplacement.wordDictionary = [newPhrase: [newReplacement]]
        dataManager.appendItem(oldTextReplacement)
        refreshData()
    }
}

// MARK: CustomHistoryView Related
extension TKSwiftDataStore {
    public func getConversationBasedContent(_ conversation: TKConversation) -> [[TKContent]] {
        
        // 1. conversation에 맞는 contents를 전부 불러옴
        let contents = dataManager.getConversationMatchingContents(conversation: conversation)
        
        print(#function, contents)
        
        // 2. contents의 날짜별 분류를 위한 contentDict와 return을 위한 targetContents
        var contentDict = [String: [TKContent]]()
        var targetContents = [[TKContent]]()
        
        // 3. 날짜별 분류 시작
        contents.forEach { content in
            if let _ = contentDict[content.createdAt.convertToDate()] {
                
            } else {
                contentDict[content.createdAt.convertToDate()] = []
            }
            
            contentDict[content.createdAt.convertToDate()]?.append(content)
        }
        
        let dateKeys = contentDict.keys.sorted(by: { $0 < $1} )
        print(#function, dateKeys)
        
        dateKeys.forEach { key in
            targetContents.append(contentDict[key] ?? [TKContent]())
        }
        
        return targetContents
    }
}
