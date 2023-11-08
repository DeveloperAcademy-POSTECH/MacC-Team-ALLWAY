//
//  HistoryItemLocationEditView.swift
//  talklat
//
//  Created by user on 11/9/23.
//

import MapKit
import SwiftUI

struct HistoryItemLocationEditView: View {
    @ObservedObject var locationStore: LocationStore
    @Binding var isShowingSheet: Bool
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
    @State private var snapShotter: MKMapSnapshotter?
    
    var body: some View {
        VStack(alignment: .leading) {
            mapHeaderView
            
            Map(
                coordinateRegion: $coordinateRegion,
                showsUserLocation: true
            )
            .aspectRatio(0.8, contentMode: .fit)
            .overlay {
                currentLocationButton
            }
            .overlay {
                customMapAnnotation
            }
            
            mapFooterView
        }
        .onAppear {
            if let coordinate = locationStore(\.userCoordinate) {
                coordinateRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    ),
                    latitudinalMeters: 500,
                    longitudinalMeters: 500
                )
            }
            locationStore.fetchCityName(coordinateRegion)
            
        }
    }
    
    var mapHeaderView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("지도를 움직여 대화 장소를 설정하세요")
            
            HStack {
                Button {
                    isShowingSheet = false
                } label: {
                    Text("취소")
                }
                .tint(Color.red)
                
                Spacer()
                
                Text("위치 정보 편집")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    takeSnapShot()
                    isShowingSheet = false
                } label: {
                    Text("저장")
                }
                .tint(Color.orange)
            }
            .padding()
        }
    }
    
    var currentLocationButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    moveToUserLocation()
                    locationStore.fetchCityName(coordinateRegion)
                } label: {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(.white)
                        .frame(width: 95, height: 44)
                        .overlay {
                            HStack {
                                Image(systemName: "location.fill")
                                Text("현위치")
                            }
                            .foregroundStyle(Color.orange)
                        }
                    
                }
                .padding()
            }
        }
    }
    
    var mapFooterView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("주소")
                .font(.headline)
                .foregroundStyle(Color.gray500)
                .padding(.bottom, 10)
            
            Text(locationStore(\.fullBlockName))
                .font(.headline)
                .padding(.bottom, 10)
            
            Button {
                locationStore.fetchCityName(coordinateRegion)
            } label: {
                HStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                    Text("주소 새로고침")
                }
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(.orange)
                        .frame(height: 38)
                }
            }
            .frame(height: 38)
            .padding(.vertical)
        }
        .padding()
    }
    
    var customMapAnnotation: some View {
        Circle()
            .fill(.orange)
            .frame(width: 22, height: 22)
    }
    
    func moveToUserLocation() {
        guard let coordinateRegion = locationStore.trackUserCoordinate(type: .get) else { return }
        self.coordinateRegion = coordinateRegion
    }
    
    func configureSnapshotter() -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        
        options.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coordinateRegion.center.latitude,
                longitude: coordinateRegion.center.longitude
            ),
            latitudinalMeters: 600,
            longitudinalMeters: 600
        )
        //MARK: 키보드가 올라오면 UIImage의 사이즈가 변경되는것을 막기 위해 -> 더 좋은 방법이 있으면 바꾸고 싶음
        options.size = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        options.showsBuildings = true
        options.pointOfInterestFilter = .includingAll
        
        return options
    }
    
    func takeSnapShot() {
        snapShotter = MKMapSnapshotter(options: configureSnapshotter())
        
        guard let snapShotter = snapShotter else { return }
        
        // async
        let snapShotQueue = DispatchQueue(label: "snapShotQueue")
        snapShotter.start(with: snapShotQueue) { snapShot, error in
            guard error == nil else { return }
            guard let snapShot = snapShot else { return }
            DispatchQueue.main.async { // ui update
                locationStore.updateLocationThumbnail(snapShot.image)
            }
        }
    }
}

#Preview {
    HistoryItemLocationEditView(locationStore: LocationStore(), isShowingSheet: .constant(false))
}
