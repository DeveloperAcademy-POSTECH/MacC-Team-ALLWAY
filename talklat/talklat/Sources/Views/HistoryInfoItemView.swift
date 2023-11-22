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
    @EnvironmentObject private var locationStore: TKLocationStore
    @StateObject  var historyInfoStore: TKHistoryInfoStore = TKHistoryInfoStore()
    @FocusState var isTextfieldFocused: Bool
    @State private var coordinateRegion = initialCoordinateRegion
    var conversation: TKConversation
    
    var body: some View {
        VStack {
            textFieldView
                .padding()
            
            mapThumbnailView
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .padding()
            
            Spacer()
        }
        .onAppear {
            historyInfoStore.reduce(\.text, into: conversation.title)
            locationStore.reduce(\.infoPlaceName, into: "위치 정보 없음")
            if
                let latitude = conversation.location?.latitude,
                let longitude = conversation.location?.longitude {
                
                // 저장되어있는것까지 확인
                let startCoordinateRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude
                    ),
                    latitudinalMeters: 500,
                    longitudinalMeters: 500)
                
                historyInfoStore.reduce(
                    \.infoCoordinateRegion,
                     into: startCoordinateRegion
                )
                
                historyInfoStore.reduce(
                    \.editCoordinateRegion,
                     into: startCoordinateRegion
                )
                
                historyInfoStore.reduce(\.text, into: conversation.title)
                
                historyInfoStore.plantFlag(startCoordinateRegion)
                
                coordinateRegion.center.latitude = latitude
                coordinateRegion.center.longitude = longitude
                
                locationStore.fetchCityName(
                    startCoordinateRegion,
                    cityNameType: .hybrid,
                    usage: .infoAndEdit
                )
                
                historyInfoStore.reduce(\.isNotChanged, into: true)
            }
        }
        .ignoresSafeArea(.keyboard)
        .background {
            Color.BaseBGWhite
                .onTapGesture {
                    isTextfieldFocused = false
                }
        }
        .sheet(
            isPresented:
                historyInfoStore.bindingEditSheet()) {
                    HistoryItemLocationEditView(
                        locationStore: locationStore,
                        historyInfoStore: historyInfoStore,
                        editCoordinateRegion: MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: initialLatitude,
                                longitude: initialLongitude
                            ),
                            latitudinalMeters: 500,
                            longitudinalMeters: 500
                        )
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
                            updateHistoryInfo()
                            historyInfoStore.reduce(\.isNotChanged, into: true)
                        } label: {
                            Text("저장")
                        }
                        .tint(Color.OR5)
                        .disabled(historyInfoStore(\.text).isEmpty)
                        .disabled(historyInfoStore(\.isNotChanged))
                    }
                }
                .fontWeight(.bold)
    }
    
    private var textFieldView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("제목")
                .font(.headline)
                .padding(.leading, 10)
                .padding(.bottom, 8)
                .foregroundStyle(Color.gray)
            
            
            TextField("", text: historyInfoStore.bindingText())
                .frame(height: 22)
                .onChange(of: historyInfoStore(\.text)) {
                    historyInfoStore.updateTextLimitMessage()
                }
                .focused($isTextfieldFocused)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            Color.GR1
                        )
                        .frame(height: 44)
                }
                .overlay {
                    HStack {
                        Spacer()
                        Button {
                            // textfield 텍스트 삭제 메서드
                            historyInfoStore.reduce(\.text, into: "")
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color(uiColor: UIColor.systemGray3))
                                .opacity(isTextfieldFocused ? 1 : 0)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
            
            Text(historyInfoStore(\.textLimitMessage))
                .padding(.leading, 10)
                .foregroundStyle(historyInfoStore(\.text).isEmpty ? Color.red : Color.gray )
        }
    }
    
    private var mapThumbnailView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("위치")
                .font(.headline)
                .padding(.leading, 10)
                .padding(.bottom, 8)
                .foregroundStyle(Color.GR5)
            
            if conversation.location == nil {
                Button {
                    isTextfieldFocused = false
                    historyInfoStore.reduce(\.isShowingSheet, into: true)
                    
                } label: {
                    Text("위치 정보 추가")
                        .font(.headline)
                        .foregroundStyle(Color.OR6)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.GR1)
                        }
                }
                .tint(Color.OR5)
            } else {
                Map(coordinateRegion: historyInfoStore.bindingInfoCoordinate(),
                    showsUserLocation: true,
                    annotationItems: historyInfoStore(\.annotationItems)
                ) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                        CustomMapAnnotation(
                            type: MapAnnotationType.fixed,
                            isFlipped: .constant(false)
                        )
                    }
                }
                
                .allowsHitTesting(false)
                .aspectRatio(1.2 ,contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Text(locationStore(\.infoPlaceName))
                            
                            Spacer()
                            
                            Button {
                                //MARK: 현재 위치 사용자 친화적인 주소로 바꿔주기
                                isTextfieldFocused = false
                                historyInfoStore.reduce(\.isShowingSheet, into: true)
                            } label: {
                                Text("조정")
                                    .tint(Color.OR6)
                            }
                        }
                        .padding()
                        .background {
                            Rectangle()
                                .fill(Color.GR1)
                        }
                    }
                }
            }
        }
        .onChange(of: historyInfoStore(\.infoCoordinateRegion)) { _ in
            historyInfoStore.reduce(\.isNotChanged, into: false)
        }
        .onChange(of: historyInfoStore(\.text)) { _ in
            historyInfoStore.reduce(\.isNotChanged, into: false)
        }
    }
    
    private func updateHistoryInfo() {
        isTextfieldFocused = false
        conversation.title = historyInfoStore(\.text)
        if let coordinate = historyInfoStore(\.infoCoordinateRegion)?.center {
            if conversation.location == nil {
                // modelContext에서 새로 데이터 생성
                conversation.location = TKLocation(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    blockName: locationStore(\.infoPlaceName)
                )
            } else {
                conversation.location?.latitude =  coordinate.latitude
                conversation.location?.longitude = coordinate.longitude
                conversation.location?.blockName = locationStore(\.infoPlaceName)
            }
        }
    }
}


extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        if lhs.center.latitude == rhs.center.latitude,
           lhs.center.longitude ==  rhs.center.longitude,
           lhs.span.latitudeDelta == rhs.span.latitudeDelta,
           lhs.span.longitudeDelta == rhs.span.longitudeDelta {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    HistoryInfoItemView(
        historyInfoStore: TKHistoryInfoStore(),
        conversation: TKConversation(
            title: "title",
            createdAt: .now,
            content: [])
    )
}
