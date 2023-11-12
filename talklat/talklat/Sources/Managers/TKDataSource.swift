//
//  ItemDataSource.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/11/23.
//

import SwiftData

/*
 Context는 ModelContainer 안에 포함되어 있고, ModelContainer를 View 계층으로 흘려보내면 View 이외의 곳에서는 쓸 수가 없다.
 그래서 ModelContainer를 아예 View 계층 밖에서 접근하도록 선언해준다.
 ItemDataSource -> Container를 접근하기 위한 View 계층이 아닌 위치
 */

final class TKDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor /// mainContext를 접근해야 하기 때문에 (컴파일 에러 방지)
    static let shared = TKDataSource() /// 단일 ModelContainer 인스턴스 사용

    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(
            for: TKConversation.self, TKTextReplacement.self
        )
        self.modelContext = modelContainer.mainContext
    }
}

// MARK: - Basic CRUD
extension TKDataSource {
    // FETCH
    internal func fetchItems<T: PersistentModel>(
        _ itemType: T.Type
    ) throws -> [T]? {
        do {
            return try modelContext.fetch(FetchDescriptor<T>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // CREATE
    internal func appendItem<T: PersistentModel>(_ item: T) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // DELETE
    internal func removeItem<T: PersistentModel>(_ item: T) {
        modelContext.delete(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - Additional Methods
extension TKDataSource {
    //
}
