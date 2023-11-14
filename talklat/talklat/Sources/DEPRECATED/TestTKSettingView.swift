//
//  TestTKSettingView.swift
//  talklat
//
//  Created by 신정연 on 11/7/23.
//

import SwiftData
import SwiftUI

// Test용 <텍스트 대치 화면>, <새 텍스트 대치 추가 화면>
//struct TestTKSettingView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    // SwiftData 연결 + R
//    @Environment(\.modelContext) private var context
//    @Query private var lists: [TKTextReplacement]
//    
//    @State private var selectedList: TKTextReplacement? = nil
//    @State private var showingAddView = false
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(lists, id: \.self) { list in
//                    Section(header: Text("단축어")) {
//                        ForEach(list.wordDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
//                            Button(action: {
//                                selectedList = list
//                            }) {
//                                Text("\(key): \(value)")
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("텍스트 교체")
//            .navigationBarItems(leading: Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                HStack {
//                    Image(systemName: "arrow.left")
//                    Text("뒤로")
//                }
//            })
//            .toolbar {
//                Button(action: {
//                    showingAddView = true
//                }) {
//                    Image(systemName: "plus")
//                }
//            }
//            .sheet(isPresented: $showingAddView) {
//                AddTextReplacementView(isPresented: self.$showingAddView)
//            }
//        }
//    }
//}


//struct AddTextReplacementView: View {
//    @Environment(\.modelContext) private var context
//    
//    @Binding var isPresented: Bool
//    
//    @State private var phrase: String = ""
//    @State private var replacement: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                HStack {
//                    Text("문구")
//                    Spacer()
//                }
//
//                TextField("줄임말을 입력해주세요 ex)아아", text: $phrase)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(22)
//                
//                HStack {
//                    Text("변환 문구")
//                    Spacer()
//                }
//                
//                TextField("대치할 텍스트를 입력해주세요 ex)아이스 아메리카노", text: $replacement)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(22)
//                
//                Spacer()
//            }
//            .padding()
//            .navigationTitle("텍스트 대치 추가")
//            .navigationBarItems(leading: Button("취소") {
//                isPresented = false
//            })
////            .navigationBarItems(trailing: Button("완료") {
////                // TODO: Save New Dictionary of TextReplacement
////                let newItem = TKTextReplacement(wordDictionary: [phrase: replacement])
////                context.insert(newItem)
////                isPresented = false
////            })
//        }
//    }
//}

//struct TestTKSettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestTKSettingView()
//    }
//}
