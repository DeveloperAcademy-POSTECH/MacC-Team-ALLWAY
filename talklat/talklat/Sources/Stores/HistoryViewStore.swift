//
//  HistoryViewStore.swift
//  talklat
//
//  Created by Ye Eun Choi on 11/6/23.
//

import Foundation
import SwiftData
import SwiftUI

final class HistoryViewStore: ObservableObject {
    @Environment(\.modelContext) private var context
    
    public func addConversation(_ conversation:TKConversation) {
        context.insert(conversation)
    }
}


