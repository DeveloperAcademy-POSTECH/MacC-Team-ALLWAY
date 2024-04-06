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

class TKLocationStore: NSObject, CLLocationManagerDelegate, TKReducer {
    // Equatable에 conform 시키기 위해 extension을 쓰는것보다는 최대한 원시타입을 씁시다 - 갓짤랑
    struct ViewState {
        var currentUserCoordinate: MKCoordinateRegion? = nil
        var currentUserPlaceName: String? = nil
        
        var authorizationStatus: CLAuthorizationStatus?
        
        var shortPlaceName: String = ""
        var longPlaceName: String = ""
        
        var returnString: String? = nil
        
        var mainPlaceName: String = NSLocalizedString("위치 정보 없음", comment: "")
        var infoPlaceName: String = NSLocalizedString("위치 정보 없음", comment: "")
        var editPlaceName: String = NSLocalizedString("위치 정보 없음", comment: "")
        
        var circularRegion: CLCircularRegion = CLCircularRegion(
            center: CLLocationCoordinate2D(
                latitude: initialLatitude,
                longitude: initialLongitude
            ),
            radius: 10,
            identifier: "circularRegion"
        )
        
        var isAuthorized: Bool {
            return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
        }
    }
    
    
    // 왜 이게 private 처리를 할 수 없을까? -> 아하 call as function을 한다음에 쓰는곳마다 keypath를 이용해서 불러와줘야하는구나
    @Published private var locationState: ViewState = ViewState()
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private let geocoder: CLGeocoder = CLGeocoder()
    
    override init() {
        super.init()
    }
    
    public func onMainViewAppear() {
        self.configureLocationManager()
        
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
        
        self.reduce(
            \.authorizationStatus,
             into: self.locationManager.authorizationStatus
        )
    }
    
    public func callAsFunction<Value: Equatable>(_ keyPath: KeyPath<ViewState, Value>) -> Value {
        self.locationState[keyPath: keyPath]
    }
    
    func reduce<Value: Equatable>
    (
        _ state: WritableKeyPath<ViewState, Value>,
        into newValue: Value
    ) {
        switch state {
        case \.currentUserCoordinate:
            withAnimation {
                self.locationState[keyPath: state] = newValue
            }
        default:
            self.locationState[keyPath: state] = newValue // 해당하는 state에 맞는 newValue를 할당해주고
        }
    }
    
    func stopLocationTracking() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func trackUserCoordinate() {
        guard let userLocation: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        
        let userCoordinate = MKCoordinateRegion(
            center: userLocation,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        
        self.reduce(\.currentUserCoordinate, into: userCoordinate)
        
        self.fetchCityName(userCoordinate, cityNameType: .short, usage: .main)
        
    }
    
    // 동네 이름을 가져와서 뿌려주기
    func fetchCityName(
        _ coordinateRegion: MKCoordinateRegion?,
        cityNameType: CityNameType,
        usage: NameUsageType
    ) {
        guard let coordinate = coordinateRegion else { return }
        
        let location = CLLocation(
            latitude: coordinate.center.latitude,
            longitude: coordinate.center.longitude
        )
        
        // MARK: 비동기 처리 및 weak self 처리 완료
        let geocoderQueue = DispatchQueue(label: "geocoderQueue")
        
        geocoderQueue.async { [weak self] in
            self?.geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil else {
                    print("Geocoder revser geocode location error: \(String(describing: error?.localizedDescription))")
                    self?.reduce(\.returnString, into: "위치 정보 없음")
                    return
                }
                guard let placemarks = placemarks else {
                    print("Error: cannot get placemarks")
                    self?.reduce(
                        \.returnString, 
                         into: NSLocalizedString("위치 정보 없음", comment: "")
                    )
                    return
                }
                
                for placemark in placemarks {
                    DispatchQueue.main.async { // UI update
                        let tmpString = self?.getCityName(
                            placeMark: placemark,
                            type: cityNameType
                        )
                        
                        guard let finalString = tmpString else {
                            print("no tmpString")
                            return
                        }
                        
                        switch usage {
                        case .main:
                            self?.reduce(
                                \.mainPlaceName, 
                                 into: finalString.first 
                                 ?? NSLocalizedString("위치 정보 없음", comment: "")
                            )
                        case .info:
                            self?.reduce(
                                \.infoPlaceName,
                                 into: finalString.first 
                                 ?? NSLocalizedString("위치 정보 없음", comment: "")
                            )
                        case .edit:
                            self?.reduce(
                                \.editPlaceName,
                                 into: finalString.first
                                 ?? NSLocalizedString("위치 정보 없음", comment: "")
                            )
                        case .infoAndEdit:
                            self?.reduce(
                                \.infoPlaceName,
                                 into: finalString.first 
                                 ?? NSLocalizedString("위치 정보 없음", comment: "")
                            )
                            self?.reduce(
                                \.editPlaceName,
                                 into: finalString.last
                                 ?? NSLocalizedString("위치 정보 없음", comment: "")
                            )
                        }
                    }
                }
            }
        }
    }
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.reduce(\.authorizationStatus, into: self.locationManager.authorizationStatus)
        
        switch self(\.authorizationStatus) {
        case .authorizedAlways, .authorizedWhenInUse:
            self.initialUserTracking()
        default:
            locationManager.requestWhenInUseAuthorization()
            self.reduce(\.currentUserCoordinate, into: nil)
            self.reduce(
                \.mainPlaceName,
                 into: NSLocalizedString("위치 정보 없음", comment: "")
            )
            self.reduce(
                \.infoPlaceName,
                 into: NSLocalizedString("위치 정보 없음", comment: "")
            )
            self.reduce(
                \.editPlaceName, 
                 into: NSLocalizedString("위치 정보 없음", comment: "")
            )
        }
        
        
    }
    
    private func initialUserTracking() {
        guard let coordinate = self.locationManager.location?.coordinate else { //MARK: 사용자 좌표를 구하지 못할 때 -> 일단은 서울역 좌표. 추후 논의를 통해 변경 예정
            self.reduce(
                \.shortPlaceName,
                 into: NSLocalizedString("위치 정보 없음", comment: "")
            )
            self.reduce(
                \.longPlaceName,
                 into: NSLocalizedString("위치 정보 없음", comment: "")
            )
            return
        }
        
        let initialUserCoordinate = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        
        self.reduce(
            \.currentUserCoordinate,
             into: initialUserCoordinate
        )
        
        self.fetchCityName(initialUserCoordinate, cityNameType: .short, usage: .main)
        
        self.makeNewRegion()
    }
    
    
    private func getCityName(placeMark: CLPlacemark, type: CityNameType) -> [String] {
        switch type {
        case .short:
//            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let subLocality = (placeMark.subLocality != nil) ? placeMark.subLocality! : ""
//            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            return ["\(locality) \(subLocality)"]
            
        case .long:
            let subAdministrativeArea = (placeMark.subAdministrativeArea != nil) ? placeMark.subAdministrativeArea! : ""
//            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let subLocality = (placeMark.subLocality != nil) ? placeMark.subLocality! : ""
            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            
            return ["\(subAdministrativeArea) \(locality) \(subLocality) \(name)"]
            
        case .hybrid:
            let subAdministrativeArea = (placeMark.subAdministrativeArea != nil) ? placeMark.subAdministrativeArea! : ""
//            let administrativeArea = (placeMark.administrativeArea != nil) ? placeMark.administrativeArea! : ""
            let locality = (placeMark.locality != nil) ? placeMark.locality! : ""
            let subLocality = (placeMark.subLocality != nil) ? placeMark.subLocality! : ""
            let name = (placeMark.name != nil) ? placeMark.name! : ""
            
            let long = "\(subAdministrativeArea) \(locality) \(subLocality) \(name)"
            let short = "\(locality) \(subLocality)"
            
            return [short, long]
        }
    }
    
    public func detectAuthorization() -> Bool {
        switch locationState.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    public func calculateDistance(_ location: TKLocation?) -> Int? {
        guard let coordinate = self(\.currentUserCoordinate)?.center else { return nil }
        guard let location = location else { return nil }
        
        let lat1 = coordinate.latitude
        let lon1 = coordinate.longitude
        let lat2 = location.latitude
        let lon2 = location.longitude
        
        let earthRadius = 6371 * 1000 // m단위
        let dLat = (lat1 - lat2).toRadians()
        let dLon = (lon1 - lon2).toRadians()
        
        let a = sin(dLat/2) * sin(dLat/2)
        + cos(lat1.toRadians()) * cos(lat2.toRadians()) * sin(dLon/2) * sin(dLon/2)
        
        let c = 2 * atan2(
            sqrt(a),
            sqrt(1-a)
        )
        
        let distanceInMeters = Double(earthRadius) * c
        return Int(distanceInMeters)
    }
    
    public func getClosestConversation(_ conversations: [TKConversation]) -> [TKConversation] {
        
        guard self.detectAuthorization() == true else { return [TKConversation]() }
        
        // 거리 순에 따른 정리
        var distanceConversationDict = [Int: TKConversation]()
        conversations.forEach { conversation in
            if let location = conversation.location {
                if let calculatedDistance = calculateDistance(location) {
                    if calculatedDistance < 4000 { // 4km 이내만 반환
                        distanceConversationDict[calculatedDistance] = conversation
                    }
                }
            }
        }
        
        let keys = distanceConversationDict.keys.sorted(by: {$0 < $1}) // 거리에 따라 key sorting
        var closeConversations = [TKConversation]()
        
        keys.forEach { key in
            if let value = distanceConversationDict[key] {
                closeConversations.append(value)
            }
        }
        
        // 가까운 10개만 잘라서 반환
        if closeConversations.count > 10 {
            return Array(closeConversations[0..<10])
        } else {
            return closeConversations
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        makeNewRegion()
    }
    
    func makeNewRegion() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        // 현재 region을 관찰하는걸 멈춤
        locationManager.stopMonitoring(for: self(\.circularRegion))
        
        // 유저 위치 다시 트래킹
        self.trackUserCoordinate()
        self.fetchCityName(
            MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ), 
            cityNameType: .short,
            usage: .main
        )
        
        // 새로운 circular region 생성
        let currentRegion = CLCircularRegion(
            center: coordinate,
            radius: 10,
            identifier: "circularRegion")
        currentRegion.notifyOnExit = true
        
        // 새로운 circular region 관찰 시작
        locationManager.startMonitoring(for: currentRegion)
        self.reduce(\.circularRegion, into: currentRegion)
    }
}


public enum LocationFetchType {
    case current
    case selected
}


// 사용자의 좌표는 nil일 수 있다.
public struct UserCoordinate: Equatable {
    var latitude: Double
    var longitude: Double
    var blockName: String
}

public enum CityNameType {
    case short
    case long
    case hybrid
}

public enum NameUsageType {
    case main
    case info
    case edit
    case infoAndEdit
}
