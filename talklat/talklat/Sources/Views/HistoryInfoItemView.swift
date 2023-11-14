//
//  HistoryInfoItemView.swift
//  talklat
//
//  Created by user on 11/9/23.
//

import MapKit
import SwiftUI

struct HistoryInfoItemView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var locationStore: LocationStore = LocationStore()
    @State var isShowingSheet: Bool = false
    @State private var text: String = "토크랫(5)"
    @State private var textLimitMessage: String = ""
    @State private var isChanged: Bool = false
    @FocusState var isTextfieldFocused: Bool
    
    //MARK: 이거 나중에 SwiftData에서 불러온 값으로 변경
    let dummyLocation: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: initialLatitude,
            longitude: initialLongitude
        ),
        latitudinalMeters: 500,
        longitudinalMeters: 500
    )
    
    var body: some View {
        VStack {
            textFieldView
                .padding()
            
            mapThumbnailView
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .clipped()
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
            HistoryItemLocationEditView(locationStore: locationStore, isShowingSheet: $isShowingSheet, coordinateRegion: dummyLocation)
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
                    .tint(Color.OR5)
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //MARK: 저장 메서드
                    isTextfieldFocused = false
                } label: {
                    Text("저장")
                }
                .tint(Color.OR5)
                .disabled(text.isEmpty == true)
            }
        }
    }
    
    private var textFieldView: some View {
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
    
    private var mapThumbnailView: some View {
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
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .clipped()
                    .aspectRatio(
                        1.5,
                        contentMode: .fit
                    )
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
