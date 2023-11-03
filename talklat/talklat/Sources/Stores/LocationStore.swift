//
//  LocationStore.swift
//  talklat
//
//  Created by user on 2023/10/31.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI
import UIKit


class LocationStore: NSObject, CLLocationManagerDelegate, MKMapViewDelegate, ObservableObject {
    // Equatable에 conform 시키기 위해 extension을 쓰는것보다는 최대한 원시타입을 씁시다 - 갓짤랑
    struct LocationState {
        var userCoordinate: UserCoordinate
        var locationName: String?
        var authorizationStatus: CLAuthorizationStatus?
    }
    
    struct UserCoordinate: Equatable {
        var userLatitude: Double = 36.014088
        var userLongitude: Double = 129.325848
    }
    
    enum LocationCallType {
        case track
        case get
    }
    
    // 왜 이게 private 처리를 할 수 없을까? -> 아하 call as function을 한다음에 쓰는곳마다 keypath를 이용해서 불러와줘야하는구나
    @Published private var locationState: LocationState = LocationState(
        userCoordinate: UserCoordinate()
    )
    private let locationManager: CLLocationManager = .init()
    private let geocoder: CLGeocoder = .init()
    private let radius: Double = 20.0
    
    override init() {
        super.init()
        
        self.configureLocationManager()
        
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways:
            break
        default:
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func configureLocationManager() {
        // location delegate
        self.locationManager.delegate = self
        
        // mapView delegate -> mapView delegate가 되려면 mapview를 이 class 안에 선언해놔야하는데 이게 맞나?
        
        // location indicator
        self.locationManager.showsBackgroundLocationIndicator = true
        
        // 위치 정확도 -> 현재 최상
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // location update 시작
        self.locationManager.startUpdatingLocation()
    }
    
    public func callAsFunction<Value: Equatable>(_ keyPath: KeyPath<LocationState, Value>) -> Value {
        self.locationState[keyPath: keyPath]
    }
    
    private func updateState<Value: Equatable>
    (
        _ state: WritableKeyPath<LocationState, Value>,
        with newValue: Value
    ) {
        switch state {
        case \.userCoordinate, \.authorizationStatus, \.locationName:
            self.locationState[keyPath: state] = newValue // 해당하는 state에 맞는 newValue를 할당해주고
        default:
            break
        }
    }
    
    func stopLocationTracking() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func trackUserCoordinate(type: LocationCallType) -> MKCoordinateRegion? {
        guard let userLocation: CLLocationCoordinate2D = locationManager.location?.coordinate else { return nil }
        
        var userCoordinate = UserCoordinate(
            userLatitude: userLocation.latitude,
            userLongitude: userLocation.longitude
        )
        
        updateState(\.userCoordinate, with: userCoordinate)
        
        switch type {
        case .track:
            return nil
        case .get:
            let userMKRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userCoordinate.userLatitude,
                    longitude: userCoordinate.userLongitude
                ),
                latitudinalMeters: 0.001,
                longitudinalMeters: 0.001
            )
            return userMKRegion
        }
    }
    
    
    
    // 동네 이름을 가져와서 뿌려주기
    func getCityName(_ coordinateRegion: MKCoordinateRegion) {
        // Geocoder사용
//        guard let location2d = locationManager.location?.coordinate else {
//            print("Cannot get user location coordinate")
//            return
//        }
        var location = CLLocation(
            latitude: coordinateRegion.center.latitude,
            longitude: coordinateRegion.center.longitude
        )
        
        
        //MARK: 이 부분 asychronous하게 바꾸고 싶다.
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Geocoder revser geocode location error: \(String(describing: error?.localizedDescription))")
                return
            }
            guard let placemarks = placemarks else {
                print("Error: cannot get placemarks")
                return
            }
            
            //MARK: 이 부분 수정. 국가, 시, 동 중에서 있는거 2개만 채택해서 넣어주기 -> 만약 1개만 있거나 다 없다면?
            
            for placemark in placemarks {
                if let locality =  placemark.locality, let subLocality = placemark.subLocality {
                    let locationName = locality + " " + subLocality
                    
                    self.updateState(\.locationName, with: locationName)
                }
            }
        }
        
    }
    
    // 무슨시 무슨동인지 맵이 보여주는 지역이 바뀌면 업데이트해주기 -> 가능하려나 -> MapView Delegate가 된다면 될거같은데
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateState(\.authorizationStatus, with: self.locationManager.authorizationStatus)
        
        switch self.locationState.authorizationStatus {
        case .authorizedAlways:
            break
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return self.locationState.authorizationStatus ?? .denied
    }
}


struct LocationTestView: View {
    @State private var isSheetOpen: Bool = false
    @State private var text: String = "Talklat(5)"
    var body: some View {
        Button {
            isSheetOpen = true
        } label: {
            Text("Push")
        }
        .sheet(isPresented: $isSheetOpen) {
            InformationEditView(isSheetOpen: $isSheetOpen, text: $text)
        }
    }
}

struct InformationEditView: View {
    @Binding var isSheetOpen: Bool
    @Binding var text: String
    @StateObject private var locationStore: LocationStore = .init()
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 36.014088,
            longitude: 129.325848
        ),
        latitudinalMeters: 0.001,
        longitudinalMeters: 0.001
    )
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                Group {
                    Text("제목")
                    
                    TextField("", text: $text)
                        .padding()
                        .background {
                            Rectangle()
                                .fill(
                                    Color(uiColor: UIColor.systemGray3)
                                )
                                .cornerRadius(12)
                        }
                        .overlay {
                            HStack {
                                Spacer()
                                Button {
                                    text = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .padding()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                    Text("\(text.count)/30")
                }
                
                switch locationStore.getAuthorizationStatus() {
                case .authorized:
                    Map(
                        coordinateRegion: $coordinateRegion,
                        showsUserLocation: true
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
                                Button {
                                    //MARK: 사용자 위치로 이동하는 로직
                                    moveToUserLocation()
                                } label: {
                                    Image(systemName: "scope")
                                        .background {
                                            Circle()
                                                .fill(.white)
                                        }
                                }
                                
                                Text(locationStore(\.locationName) ?? "위치정보 없음")
                                
                                Spacer()
                                
                                Button {
                                    //MARK: 현재 위치 사용자 친화적인 주소로 바꿔주기
                                    locationStore.getCityName(coordinateRegion)
                                } label: {
                                    Text("조정")
                                }
                            }
                            .padding()
                            .background {
                                Rectangle()
                                    .fill(Color(uiColor: UIColor.systemGray3))
                            }
                        }
                    }
                    .onAppear {
                        locationStore.trackUserCoordinate(type: .track)
                        coordinateRegion = MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: locationStore(\.userCoordinate.userLatitude),
                                longitude: locationStore(\.userCoordinate.userLongitude)
                            ),
                            latitudinalMeters: 0.001,
                            longitudinalMeters: 0.001
                        )
                        locationStore.getCityName(coordinateRegion)
                    }
                default:
                    Text("지도 안보임")
                }
            }
            .navigationTitle("정보 편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button {
                        isSheetOpen = false
                    } label: {
                        Text("취소")
                            .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //MARK: 저장 로직
                        isSheetOpen = false
                    } label: {
                        Text("완료")
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
    
    func moveToUserLocation() {
        guard let coordinateRegion = locationStore.trackUserCoordinate(type: .get) else { return }
        self.coordinateRegion = coordinateRegion
    }
}

struct LocationTestViewPreview: PreviewProvider {
    static var previews: some View {
        LocationTestView()
    }
}

