//
//  HistoryInfoItemView.swift
//  talklat
//
//  Created by user on 11/9/23.
//

import MapKit
import SwiftData
import SwiftUI

struct HistoryInfoItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var locationStore: LocationStore
    
    @State private var isShowingSheet: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var text: String = "토크랫(5)"
    @State private var textLimitMessage: String = ""
    @State private var isChanged: Bool = false
    @State private var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: initialLatitude,
            longitude: initialLongitude
        ),
        latitudinalMeters: 500,
        longitudinalMeters: 500
    )
    @FocusState var isTextfieldFocused: Bool
    
    let sampleImageData: Data = UIImage(named: "TalklatLogo")!.pngData().unsafelyUnwrapped
    
    //MARK: 추후 전역 SwiftDataStore가 생기면 그걸 끌어오기
    var dataStore: TKSwiftDataStore = TKSwiftDataStore()
    // 그냥 Bindable로 받아와서 처리해주면 되지 않을까?
    var conversation: TKConversation
    
    // 저장사항이 생긴지 아닌지를 판단하는 computed property
    private var hasChanges: Bool {
        guard conversation.title == text else { return true }
        guard conversation.location?.latitude == coordinateRegion.center.latitude, conversation.location?.longitude == coordinateRegion.center.longitude else { return true }
        guard conversation.location?.mapThumbnail == locationStore(\.mapThumbnail) else { return true }
        return false
    }
    
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
            HistoryItemLocationEditView(
                locationStore: locationStore,
                isShowingSheet: $isShowingSheet,
                coordinateRegion: $coordinateRegion
            )
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
        .onAppear {
            text = conversation.title
            guard
                let latitude = conversation.location?.latitude,
                let longitude = conversation.location?.longitude else { return }
            coordinateRegion.center.latitude = latitude
            coordinateRegion.center.longitude = longitude
        }
    }
    
    private var textFieldView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(conversation.title)
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
                .foregroundStyle(Color.GR5)
            
            switch conversation.location?.mapThumbnail {
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
                .tint(Color.OR5)
                .padding(.vertical)
                
            default:
                Image(uiImage: UIImage(
                    data: locationStore(\.mapThumbnail) ?? sampleImageData
                )!)
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
                                Text(locationStore(\.selectedShortPlaceMark))
                                
                                Spacer()
                                
                                Button {
                                    //MARK: 현재 위치 사용자 친화적인 주소로 바꿔주기
                                    isTextfieldFocused = false
                                    isShowingSheet = true
                                } label: {
                                    Text("조정")
                                        .tint(Color.OR5)
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
    
    private func updateHistoryInfo() {
        isTextfieldFocused = false
        conversation.title = text
        if conversation.location == nil {
            // modelContext에서 새로 데이터 생성
            conversation.location = TKLocation(
                latitude: coordinateRegion.center.latitude,
                longitude: coordinateRegion.center.longitude,
                blockName: locationStore(\.selectedShortPlaceMark),
                mapThumbnail: locationStore(\.mapThumbnail)
            )
        } else {
            conversation.location?.latitude =  coordinateRegion.center.latitude
            conversation.location?.longitude = coordinateRegion.center.longitude
            conversation.location?.blockName = locationStore(\.selectedShortPlaceMark)
            conversation.location?.mapThumbnail = locationStore(\.mapThumbnail)
        }
    }
}

