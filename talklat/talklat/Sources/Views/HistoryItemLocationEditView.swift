//
//  HistoryItemLocationEditView.swift
//  talklat
//
//  Created by user on 11/9/23.
//

import MapKit
import SwiftUI

struct HistoryItemLocationEditView: View, FirebaseAnalyzable {
    @ObservedObject var locationStore: TKLocationStore
    @ObservedObject var historyInfoStore: TKHistoryInfoStore
    @State private var isFlipped = false
    @State var editCoordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: initialLatitude,
            longitude: initialLongitude
        ),
        latitudinalMeters: 500,
        longitudinalMeters: 500
    )
    
    let firebaseStore: any TKFirebaseStore = HistoryInfoEditLocationFirebaseStore()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Map(coordinateRegion: $editCoordinateRegion,
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
                .overlay {
                    currentLocationButton
                }
                .overlay {
                    CustomMapAnnotation(
                        type: MapAnnotationType.movable,
                        isFlipped: historyInfoStore.bindingFlipped()
                    )
                }
                
                mapFooterView
            }
            .frame(maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    BDText(
                        text: "위치 정보 편집",
                        style: .H1_B_130
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
//                        firebaseStore.userDidAction(
//                            .tapped,
//                            "close",
//                            nil
//                        )
                        firebaseStore.userDidAction(.tapped(.close))
                        historyInfoStore.reduce(\.isShowingSheet, into: false)
                    } label: {
                        Text("닫기")
                    }
                    .tint(Color.OR5)
                }
            }
            .onAppear {
                firebaseStore.userDidAction(.viewed)
                editCoordinateRegion = historyInfoStore(\.editCoordinateRegion) ?? initialCoordinateRegion
                
                locationStore.fetchCityName(
                    historyInfoStore(\.editCoordinateRegion),
                    cityNameType: .long,
                    usage: .edit
                )
            }
        }
    }
    
    private var mapHeaderView: some View {
        HStack {
            BDText(
                text: "위치 정보 편집",
                style: .H1_B_130
            )
            
            Button {
                historyInfoStore.reduce(
                    \.isShowingSheet,
                     into: false
                )
            } label: {
                Text("닫기")
            }
            .tint(Color.OR5)
        }
        .padding()
    }
    
    private var currentLocationButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                switch locationStore(\.authorizationStatus) {
                case .authorizedAlways, .authorizedWhenInUse:
                    Button {
//                        firebaseStore.userDidAction(
//                            .tapped,
//                            "myLocation",
//                            nil
//                        )
                        firebaseStore.userDidAction(.tapped(.myLocation))
                        moveToUserLocation()
                        
                        if let _ = historyInfoStore(\.editCoordinateRegion) {
                            locationStore.fetchCityName(
                                historyInfoStore(\.editCoordinateRegion),
                                cityNameType: .long,
                                usage: .edit
                            )
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 26)
                            .fill(Color.BaseBGWhite)
                            .frame(width: 95, height: 44)
                            .overlay {
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("현위치")
                                }
                                .foregroundStyle(Color.OR5)
                            }
                        
                    }
                    .padding()
                default:
                    Button {
                        // MARK: 위치정보 설정 페이지로 넘어가기
                        
                    } label: {
                        Circle()
                            .fill(Color.BaseBGWhite)
                            .frame(width: 44)
                            .overlay {
                                Image(systemName: "location.slash.fill")
                            }
                    }
                }
                
            }
        }
    }
    
    private var mapFooterView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(locationStore(\.editPlaceName))
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Button {
//                firebaseStore.userDidAction(
//                    .tapped, 
//                    "pointPin",
//                    nil
//                )
                firebaseStore.userDidAction(.tapped(.pointPin))
                historyInfoStore.reduce(
                    \.infoCoordinateRegion,
                     into: editCoordinateRegion
                )
                
                historyInfoStore.reduce(
                    \.editCoordinateRegion,
                     into: editCoordinateRegion
                )
                
                let coordinateRegion = historyInfoStore.bindingEditCoordinate().wrappedValue
                
                locationStore.fetchCityName(
                    coordinateRegion,
                    cityNameType: .hybrid,
                    usage: .infoAndEdit)
                
                
                historyInfoStore.plantFlag(coordinateRegion)
                
                withAnimation {
                    historyInfoStore.reduce(\.isFlipped, into: !historyInfoStore(\.isFlipped))
                }
            } label: {
                HStack {
                    Text("이 위치에 핀 꼽기")
                }
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(height: 38)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.OR5)
                        .frame(height: 56)
                }
            }
            .padding(.vertical)
            
        }
        .padding()
    }
    
    private func moveToUserLocation() {
        
        guard let coordinateRegion = locationStore(\.currentUserCoordinate) else {
            return
        }
        
        historyInfoStore.reduce(
            \.editCoordinateRegion,
             into: coordinateRegion
        )
        editCoordinateRegion = coordinateRegion
    }
    
}

public struct CustomAnnotationInfo: Identifiable, Equatable {
    public let id: UUID = UUID()
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}

private struct CustomMapPinModifier: ViewModifier {
    @Binding var isFlipped: Bool
    let mapAnnotationType: MapAnnotationType
    
    func body(content: Content) -> some View {
        switch mapAnnotationType {
        case .fixed:
            content
        case .movable:
            content
                .rotation3DEffect( isFlipped == true ?
                    .degrees(360) : .zero,
                                   axis: (x: 0, y: 1, z: 0)
                )
                .animation(.default, value: isFlipped)
        }
        
    }
}


struct CustomMapAnnotation: View {
    let type: MapAnnotationType
    @Binding var isFlipped: Bool
    var body: some View {
        VStack(spacing: 0) {
            switch type {
            case .movable:
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.OR5)
                    .frame(width: 191, height: 30)
                    .overlay {
                        Text("지도를 움직여 위치를 설정 하세요")
                            .foregroundStyle(Color.white)
                            .font(.footnote)
                            .fontWeight(.regular)
                    }
                    .padding(.bottom, 12)
            case .fixed:
                Spacer()
                    .frame(height: 42)
            }
            
            VStack(spacing: 0) {
                Image("TKMappAnnotation")
            }
            .modifier(CustomMapPinModifier(isFlipped: $isFlipped, mapAnnotationType: type))
        }
        .padding(.bottom, 85)
    }
    
}

#Preview {
    HistoryItemLocationEditView(
        locationStore: TKLocationStore(),
        historyInfoStore: TKHistoryInfoStore(),
        editCoordinateRegion: MKCoordinateRegion(
            center:
                CLLocationCoordinate2D(
                    latitude: initialLatitude,
                    longitude: initialLongitude
                ),
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
    )
}
