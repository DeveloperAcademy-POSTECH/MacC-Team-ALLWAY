//
//  TKHistoryView.swift
//  talklat
//
//  Created by 신정연 on 2023/10/16.
//

import SwiftUI

struct HistoryItem: Identifiable {
//    var id: ObjectIdentifier
    var id: UUID
    enum MessageType {
        case question, answer
    }
    let text: String
    let type: MessageType
}

//(Test용)
struct TKHistoryView: View {
    @ObservedObject var appViewStore: AppViewStore
   
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(appViewStore.historyItems, id: \.id) { item in
                    if !item.text.isEmpty {
                        if item.type == .question {
                            HStack {
                                Spacer()
                                Text(item.text)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                            }
                        } else {
                            HStack {
                                Text(item.text)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


struct TKHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        let previewStore = AppViewStore(
            communicationStatus: .writing,
            questionText: "",
            currentAuthStatus: .authCompleted
        )
        previewStore.historyItems = [
            HistoryItem(id: UUID(), text: "잠이 옵니다", type: .question),
            HistoryItem(id: UUID(), text: "그럴 수 있어요", type: .answer),
            HistoryItem(id: UUID(), text: "아이스아메리카노 있나요?", type: .question),
            HistoryItem(id: UUID(), text: "테스트 해보시겠어요", type: .answer),
        ]
        
        return TKHistoryView(appViewStore: previewStore)
    }
}
