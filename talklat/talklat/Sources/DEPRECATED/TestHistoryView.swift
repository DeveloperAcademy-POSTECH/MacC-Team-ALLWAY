//
//  TKHistoryView.swift
//  talklat
//
//  Created by 신정연 on 2023/10/16.
//

import SwiftUI

//(Test용)
//struct TestHistoryView: View {
//    @ObservedObject var appViewStore: AppViewStore
//   
//    var body: some View {
//        ScrollView {
//            LazyVStack(spacing: 12) {
//                ForEach(appViewStore.historyItems, id: \.id) { item in
//                    if !item.text.isEmpty {
//                        if item.type == .question {
//                            HStack {
//                                Spacer()
//                                Text(item.text)
//                                    .padding()
//                                    .background(Color.gray)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(15)
//                            }
//                        } else {
//                            HStack {
//                                Text(item.text)
//                                    .padding()
//                                    .background(Color.gray)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(15)
//                                Spacer()
//                            }
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}

//struct TKHistoryViewA_Previews: PreviewProvider {
//    static var previews: some View {
//        TestHistoryView(appViewStore: AppViewStore())
//    }
//}
