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
    // HistoryListView에서 쓰이는 specific fetch
    public func getLocationBasedConversations(location: TKLocation) -> [TKConversation] {
        let conversations = dataManager.getLocationMatchingConversations(location: location)
        return conversations
    }
    
    // HistoryListSearchView에서 쓰이는 specific fetch
    public func getContentBasedLocations(contents: [TKContent]) -> [TKLocation] {
        contents.forEach { content in
            var locations = dataManager.getContentMatchingLocations(content: content)
        }
        return filterDuplicatedBlockNames(locations: locations)
    }
    
    // 중복되는 blockName을 제거한 [TKLocation]
    public func filterDuplicatedBlockNames(locations: [TKLocation]) -> [TKLocation] {
        let groupedLocations = Dictionary(grouping: locations, by: { $0.blockName })
        let uniqueLocations = groupedLocations.compactMap { $0.value.first }
        return uniqueLocations
    }
}

// MARK: TextReplacement Related
extension TKSwiftDataStore {
    // MARK: 기본 Create
    public func createTextReplacement(phrase: String, replacement: String) {
        let newTextReplacement = TKTextReplacement(wordDictionary: [phrase: [replacement]])
        dataManager.appendItem(newTextReplacement)
        refreshData()
    }
    
//    public func findReplacement(for inputText: String) -> [String]? {
//        return replacements.first(where: { $0.wordDictionary.keys.contains(inputText) })?.wordDictionary[inputText]
//    }
//
//    // TODO: UI작업과 같이 할 것
//    public func updateTextReplacement(
//        phrase: TKTextReplacement,
//        replacement: TKTextReplacement
//    ) {
//        
//    }
//    
//    public func deleteTextReplacement(textReplacement: TKTextReplacement) {
//        modelContext.delete(textReplacement)
//    }
    
    // MARK: 리스트에서 특정 키에 해당하는 값을 찾는 메서드
//    func findValueForKeyInLists(key: String, lists: [TKTextReplacement]) -> String? {
//        return lists.first(where: { $0.wordDictionary[key] != nil })?.wordDictionary[key]
//    }
    public func updateTextReplacement(oldTextReplacement: TKTextReplacement, newPhrase: String, newReplacement: String) {
        
        oldTextReplacement.wordDictionary = [newPhrase: [newReplacement]]
        
        dataManager.appendItem(oldTextReplacement)
        refreshData()
    }
}
