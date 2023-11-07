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
//    @Bindable private var location: TKLocation = TKLocation(latitude: 0, longitude: 0)
    
//    Bindable을 사용하게 될 경우 사용할 메서드
//    func setLocation(_ object: TKLocation) {
//        self.location = object
//        self.saveContext()
//    }
    
    func createLocation(conversation: TKConversation, location: TKLocation) throws {
        context.insert(location)
        conversation.location = location
        
        saveContext()
    }
    
    func readLocation(conversation: TKConversation) -> TKLocation? {
        guard let location = conversation.location else { return nil }
        return location
    }
    
    func updateLocation(conversation: TKConversation, newLocation: TKLocation) {
        guard let oldLocationValue: TKLocation = conversation.location else { return } // conversation에 location이 nil이 아닌지 확인
        guard let oldLocationModel: TKLocation = context.registeredModel(for: oldLocationValue.persistentModelID) else { return } // location이 context안에 존재하는지 확인
        
        // fetch 하는 과정
        let predicate = #Predicate<TKLocation> {
            $0.persistentModelID == oldLocationModel.persistentModelID
        }
        let fetchDescriptor = FetchDescriptor<TKLocation>(predicate: predicate)
        guard let fetchedLocations = try? context.fetch(fetchDescriptor), fetchedLocations.count == 1, let fetchedLocation = fetchedLocations.first  else { return } // predicate를 이용해 하나의 TKLocation만 fetch해오기
        
        // fetchedLocation은 그대로인데 이렇게 안의 내용물을 바꾼다면 이게 context.hasChanged를 통과할 수 있을까?
        fetchedLocation.latitude = newLocation.latitude
        fetchedLocation.longitude = newLocation.longitude
        fetchedLocation.blockName = newLocation.blockName
        
        saveContext()
        
        // Bindable에 더미 값을 넣어놓고, 그냥 그거를 쓰면 안될까요?
//        self.setLocation(newLocation)
    }
    
    func deleteLocation(conversation: TKConversation, location: TKLocation) {
        conversation.location = nil
        context.delete(location)
        
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
