//
//  HistoryInfoItemView.swift
//  talklat
//
//  Created by user on 11/9/23.
//

import SwiftUI

struct HistoryInfoItemView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationStore: LocationStore = LocationStore()
    @State var isShowingSheet: Bool = false
    @State private var text: String = "토크랫(5)"
    @State private var textLimitMessage: String = ""
    @FocusState var isTextfieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                textFieldView
                    .padding()
                
                mapThumbnailView
                    .padding()
                
                Spacer()
            }
            .background {
                Color.white
                    .onTapGesture {
                        isTextfieldFocused = false
                    }
            }
            .sheet(isPresented: $isShowingSheet) {
                HistoryItemLocationEditView(locationStore: locationStore, isShowingSheet: $isShowingSheet)
            }
            .navigationTitle("정보")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isTextfieldFocused = false
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("대화")
                        }
                        .tint(Color.orange)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //MARK: 저장 메서드
                        isTextfieldFocused = false
                    } label: {
                        Text("저장")
                    }
                    .tint(Color.orange)
                    .disabled(text.isEmpty == true)
                }
            }
        }
    }
    
    var textFieldView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("제목")
                .padding(.leading, 10)
                .foregroundStyle(Color.gray)
            
            
            TextField("", text: $text)
                .onChange(of: text) {
                    if text.count >= 30 {
                        text = String(text.prefix(30))
                        textLimitMessage = "30/30"
                    } else if text.count == 0 {
                        textLimitMessage = "한 글자 이상 입력해주세요."
                    } else {
                        textLimitMessage = "\(text.count)/30"
                    }
                }
                .focused($isTextfieldFocused)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            Color(uiColor: UIColor.systemGray5)
                        )
                }
                .frame(height: 44)
                .overlay {
                    HStack {
                        Spacer()
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color(uiColor: UIColor.systemGray3))
                                .opacity(isTextfieldFocused ? 1 : 0)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            
            Text(textLimitMessage)
                .padding(.leading, 10)
                .foregroundStyle(text.isEmpty ? Color.red : Color.gray )
        }
        .onAppear {
            if text.isEmpty {
                textLimitMessage = "한 글자 이상 입력해주세요."
            } else {
                textLimitMessage = "\(text.count)/30"
            }
        }
    }
    
    var mapThumbnailView: some View {
        VStack(alignment: .leading) {
            Text("위치")
                .font(.headline)
                .padding(.leading, 10)
                .foregroundStyle(Color.gray500)
            
            switch locationStore(\.locationThumbnail) {
            case nil:
                Button {
                    isTextfieldFocused = false
                    isShowingSheet = true
                } label: {
                    Text("위치 정보 추가")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(uiColor: UIColor.systemGray5))
                            
                        }
                }
                .tint(Color.orange)
                .padding(.vertical)
                
            default:
                Image(uiImage: locationStore(\.locationThumbnail) ?? UIImage(named: "TalklatLogo")!)
                    .aspectRatio(
                        1.0,
                        contentMode: .fit
                    )
                    .overlay {
                        Circle()
                            .fill(.orange)
                            .frame(width: 15, height: 15)
                            .opacity(0.5)
                    }
                    .overlay {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Text(locationStore(\.shortBlockName))
                                
                                Spacer()
                                
                                Button {
                                    //MARK: 현재 위치 사용자 친화적인 주소로 바꿔주기
                                    isTextfieldFocused = false
                                    isShowingSheet = true
                                } label: {
                                    Text("조정")
                                        .tint(.orange)
                                }
                            }
                            .padding()
                            .background {
                                Rectangle()
                                    .fill(Color(uiColor: UIColor.systemGray3))
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    HistoryInfoItemView()
}
