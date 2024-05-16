//
//  HistoryInfoItemView.swift
//  talklat
//
//  Created by user on 11/9/23.
//

import MapKit
import SwiftData
import SwiftUI

struct HistoryInfoItemView: View, FirebaseAnalyzable {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var locationStore: TKLocationStore
    @StateObject  var historyInfoStore: TKHistoryInfoStore = TKHistoryInfoStore()
    @FocusState var isTextfieldFocused: Bool
    @State private var coordinateRegion: MKCoordinateRegion = initialCoordinateRegion
    @State private var isShowingAlert: Bool = false
    var conversation: TKConversation
    
    let firebaseStore: any TKFirebaseStore = HistoryInfoEditFirebaseStore()
    
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
            locationStore.reduce(
                \.infoPlaceName,
                 into: NSLocalizedString("위치 정보 없음", comment: "")
            )
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
            
            firebaseStore.userDidAction(
                .viewed,
                .historyType(
                    conversation,
                    locationStore(\.infoPlaceName))
            )
        }
        .ignoresSafeArea(.keyboard)
        .background {
            Color.ExceptionWhiteW8
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
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            firebaseStore.userDidAction(.tapped(.back))
                            if historyInfoStore.saveButtonDisabled(conversation) {
                                isTextfieldFocused = false
                                dismiss()
                            } else {
                                historyInfoStore.reduce(\.isShowingAlert, into: true)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .bold()
                                
                                BDText(
                                    text: NSLocalizedString("대화", comment: ""),
                                    style: .H1_B_130
                                )
                            }
                            .tint(Color.OR5)
                        }
                    }
                    
                    // Navigation Title
                    ToolbarItem(placement: .principal) {
                        BDText(
                            text: NSLocalizedString("정보", comment: ""),
                            style: .H1_B_130
                        )
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            firebaseStore.userDidAction(
                                .tapped(.save),
                                .historyType(conversation, locationStore(\.infoPlaceName))
                            )
                            //MARK: 저장 메서드
                            isTextfieldFocused = false
                            updateHistoryInfo()
                            historyInfoStore.reduce(\.isNotChanged, into: true)
                        } label: {
                            Text("저장")
                        }
                        .tint(Color.OR5)
                        .disabled(historyInfoStore.saveButtonDisabled(conversation))
                    }
                }
                .fontWeight(.bold)
                .showTKAlert(
                    isPresented: historyInfoStore.bindingAlert(),
                    style: .editCancellation(
                        title: NSLocalizedString("취소", comment: "")
                    ),
                    onDismiss: {
                        firebaseStore.userDidAction(.tapped(.alertCancel(firebaseStore.viewId)))
                    },
                    confirmButtonAction: ({
                        firebaseStore.userDidAction(.tapped(.alertBack(firebaseStore.viewId)))
                        historyInfoStore.reduce(\.isShowingAlert, into: false)
                        dismiss()
                    }),
                    confirmButtonLabel: {
                        BDText(text: "네, 취소할래요.", style: .H2_SB_135)
                    }
                )
                .background(Color.ExceptionWhiteW8)
    }
    
    private var textFieldView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(NSLocalizedString("제목", comment: ""))
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
                            firebaseStore.userDidAction(.tapped(.eraseAll))
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
                .onChange(of: isTextfieldFocused) { _ in
                    if $isTextfieldFocused.wrappedValue == true {
                        firebaseStore.userDidAction(.tapped(.field))
                    }
                }
            
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
                    showsUserLocation: false,
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
                                firebaseStore.userDidAction(.tapped(.adjustLocation))
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
                                .fill(Color.ExceptionWhite17)
                        }
                    }
                }
            }
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

#Preview {
    HistoryInfoItemView(
        historyInfoStore: TKHistoryInfoStore(),
        conversation: TKConversation(
            title: "title",
            createdAt: .now,
            content: [])
    )
}
