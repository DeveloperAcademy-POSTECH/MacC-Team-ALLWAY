//
//  LocationDataManager.swift
//  talklat
//
//  Created by user on 11/6/23.
//

import SwiftData
import SwiftUI

class LocationDataManager {
    @Environment(\.modelContext) private var context
    
    func createLocation(conversation: TKConversation, location: TKLocation) throws {
        context.insert(location)
        conversation.location = location
        
        context.saveContext()
    }
    
    func readLocation(conversation: TKConversation) -> TKLocation? {
        guard let location = conversation.location else { return nil }
        return location
    }
    
    func updateLocation(conversation: TKConversation, newLocation: TKLocation) {
        guard let oldLocationValue: TKLocation = conversation.location else { return } // conversation에 location이 nil이 아닌지 확인
        
        guard 
            let fetchedLocation = try? context.fetchSamePersistentModel(oldLocationValue) else { return }
        // fetchedLocation은 그대로인데 이렇게 안의 내용물을 바꾼다면 이게 context.hasChanged를 통과할 수 있을까?
        fetchedLocation.latitude = newLocation.latitude
        fetchedLocation.longitude = newLocation.longitude
        fetchedLocation.blockName = newLocation.blockName
        
        context.saveContext()
    }
    
    func deleteLocation(conversation: TKConversation, location: TKLocation) {
        guard
            let fetchedLocation = try? context.fetchSamePersistentModel(location) else { return }

        conversation.location = nil
        context.delete(fetchedLocation)
        
        context.saveContext()
    }
}

extension ModelContext {
    // 해당 Model type을 container에서 전부 불러오는 함수
    func fetchPersistentModelItems<T>(_ object: T) -> [T]? where T: PersistentModel {
        // fetch 하는 과정
        let fetchDescriptor = FetchDescriptor<T>()
        guard let fetchedItems = try? self.fetch(fetchDescriptor) else { return nil }
        
        return fetchedItems
    }
    
    // 같은 persistentModelID를 갖고 있는 하나의 model만 불러오는 함수
    func fetchSamePersistentModel<T>(_ object: T) throws -> T? where T: PersistentModel {
        guard let objectModel: T = self.registeredModel(for: object.persistentModelID) else { return nil } // location이 context안에 존재하는지 확인
        
        // fetch 하는 과정
        let predicate = #Predicate<T> {
            $0.persistentModelID == objectModel.persistentModelID
        }
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        guard let fetchedItems = try? self.fetch(fetchDescriptor),
                let fetchedItem = fetchedItems.first else { return nil }
        
        return fetchedItem
    }
    
    // 변경 사항이 있을때만 context를 저장하는 함수 -> CoreData에서는 이렇게 하라고 했음. SwiftData는 다를수도
    func saveContext() {
        if self.hasChanges {
           try? self.save()
        }
    }
}
