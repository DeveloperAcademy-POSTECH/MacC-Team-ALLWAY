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

class LocationStore: NSObject, CLLocationManagerDelegate, ObservableObject {
    // Equatable에 conform 시키기 위해 extension을 쓰는것보다는 최대한 원시타입을 씁시다 - 갓짤랑
    struct LocationState {
        var currentUserCoordinate: UserCoordinate? = nil
        var currentPlaceMark: CLPlacemark? = nil
        
        var selectedPlaceMark: CLPlacemark? = nil
        var locationThumbnail: UIImage? = nil
        
        var authorizationStatus: CLAuthorizationStatus?
        
        var currentFullPlaceMark: String {
            guard let placeMark = currentPlaceMark else { return "위치 정보 없음" }
            
            let subAdministrativeArea = (placeMark.subAdministrativeArea != nil) ? placeMark.subAdministrativeArea! : ""
            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let subLocality = (placeMark.subLocality != nil) ? placeMark.subLocality! : ""
            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            return "\(administrativeArea) \(subAdministrativeArea) \(locality) \(subLocality) \(name)"
        }
        
        //MARK: 짧은 장소 이름 수정예정
        var currentShortPlaceMark: String {
            guard let placeMark = currentPlaceMark else { return "위치 정보 없음"}
            
            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let subAdministrativeArea = (placeMark.subAdministrativeArea != nil) ? placeMark.subAdministrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            return "\(administrativeArea) \(name)"
        }
        
        var selectedFullPlaceMark: String {
            guard let placeMark = selectedPlaceMark else { return "위치 정보 없음" }
            
            let subAdministrativeArea = (placeMark.subAdministrativeArea != nil) ? placeMark.subAdministrativeArea! : ""
            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let subLocality = (placeMark.subLocality != nil) ? placeMark.subLocality! : ""
            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            return "\(administrativeArea) \(subAdministrativeArea) \(locality) \(subLocality) \(name)"
        }
        
        //MARK: 짧은 장소 이름 수정예정
        var selectedShortPlaceMark: String {
            guard let placeMark = selectedPlaceMark else { return "위치 정보 없음"}
            
            let subAdministrativeArea = (placeMark.subAdministrativeArea != nil) ? placeMark.subAdministrativeArea! : ""
            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            return "\(administrativeArea) \(name)"
        }
    }
    
    // 사용자의 좌표는 nil일 수 있다.
    struct UserCoordinate: Equatable {
        var latitude: Double
        var longitude: Double
        var blockName: String
    }
    
    // 왜 이게 private 처리를 할 수 없을까? -> 아하 call as function을 한다음에 쓰는곳마다 keypath를 이용해서 불러와줘야하는구나
    @Published private var locationState: LocationState = LocationState()
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private let geocoder: CLGeocoder = CLGeocoder()
    
    
    override init() {
        super.init()

        self.configureLocationManager()
        
        switch self.locationManager.authorizationStatus {
        case .authorizedAlways:
            break
        default:
            self.locationManager.requestAlwaysAuthorization()
        }
        
        self.updateState(\.authorizationStatus, with: self.locationManager.authorizationStatus)
        
        // 초기 사용자 위치 & 주소 가져오기
        self.initialUserTracking()
    }
    
    private func configureLocationManager() {
        // location delegate
        self.locationManager.delegate = self
        
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
        case \.currentUserCoordinate:
            withAnimation {
                self.locationState[keyPath: state] = newValue
            }
        case \.authorizationStatus, \.locationThumbnail, \.currentPlaceMark, \.selectedPlaceMark:
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
        
        let userCoordinate = UserCoordinate(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
            blockName: "위치 정보 없음"
        )
        
        updateState(\.currentUserCoordinate, with: userCoordinate)
        fetchCityName(
            MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ),
            of: .current
        )
        
        switch type {
        case .update:
            return nil
        case .get:
            let userMKRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userCoordinate.latitude,
                    longitude: userCoordinate.longitude
                ),
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )
            return userMKRegion
        }
    }
    
    // 동네 이름을 가져와서 뿌려주기
    func fetchCityName(_ coordinateRegion: MKCoordinateRegion, of type: LocationFetchType) {
        let location = CLLocation(
            latitude: coordinateRegion.center.latitude,
            longitude: coordinateRegion.center.longitude
        )
        
        // MARK: 비동기 처리 및 weak self 처리 완료
        let geocoderQueue = DispatchQueue(label: "geocoderQueue")
        geocoderQueue.async { [weak self] in
            self?.geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil else {
                    print("Geocoder revser geocode location error: \(String(describing: error?.localizedDescription))")
                    return
                }
                guard let placemarks = placemarks else {
                    print("Error: cannot get placemarks")
                    return
                }
                
                //MARK: placemark 자체를 저장하고 추후 computed property로 처리
                for placemark in placemarks {
                    DispatchQueue.main.async { // UI update
                        switch type {
                        case .current:
                            self?.updateState(\.currentPlaceMark, with: placemark)
                        case .selected:
                            self?.updateState(\.selectedPlaceMark, with: placemark)
                        }
                    }
                }
            }
        }
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateState(\.authorizationStatus, with: self.locationManager.authorizationStatus)
        
        switch self.locationState.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.initialUserTracking()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func initialUserTracking() {
        guard let coordinate = self.locationManager.location?.coordinate else { //MARK: 사용자 좌표를 구하지 못할 때 -> 일단은 서울역 좌표. 추후 논의를 통해 변경 예정
            return
        }
        
        self.fetchCityName(
            MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            ),
            latitudinalMeters: 500,
            longitudinalMeters: 500
        ),
            of: .current
        )
        
        self.updateState(\.currentUserCoordinate, 
                          with: UserCoordinate(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude,
                            blockName: self.locationState.currentShortPlaceMark
        ))
    }
    
    func fetchCurrentCityName() {
        guard let userCoordinate = self.locationManager.location?.coordinate else { return }
        
        fetchCityName(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: userCoordinate.latitude,
                    longitude: userCoordinate.longitude
                ),
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ),
            of: .current
        )
    }
    
    @MainActor
    func updateLocationThumbnail(_ image: UIImage?) {
        guard let image = image else { return }
        self.updateState(\.locationThumbnail, with: image)
    }
    
    func detectAuthorization() -> Bool {
        switch locationState.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
}


public enum LocationFetchType {
    case current
    case selected
}
