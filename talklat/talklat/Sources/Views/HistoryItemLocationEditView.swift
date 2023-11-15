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
    @Binding var coordinateRegion: MKCoordinateRegion
    @State private var snapShotter: MKMapSnapshotter?
    @State private var annotationItems: [CustomAnnotationInfo] = [CustomAnnotationInfo]()
    @State private var isFlipped: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Map(coordinateRegion: $coordinateRegion, showsUserLocation: true, annotationItems: annotationItems) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)) {
                        CustomMapAnnotation(.fixed)
                    }
                }
                .overlay {
                    currentLocationButton
                }
                .overlay {
                    CustomMapAnnotation(.movable)
                }
                
                mapFooterView
            }
            .frame(maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("위치 정보 편집")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSheet = false
                    } label: {
                        Text("닫기")
                    }
                    .tint(Color.OR5)
                }
            }
            .onAppear {
                locationStore.fetchCityName(coordinateRegion, of: .selected)
                //MARK: 저장된 로케이션이 있다면 넣어주는 로직
            }
        }
    }
    
    private var mapHeaderView: some View {
        HStack {
            Text("위치 정보 편집")
                .font(.headline)
            
            Button {
                isShowingSheet = false
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
                        moveToUserLocation()
                        locationStore.fetchCityName(coordinateRegion, of: .current)
                    } label: {
                        RoundedRectangle(cornerRadius: 26)
                            .fill(.white)
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
                            .fill(.white)
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
            Text(locationStore(\.selectedFullPlaceMark))
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Button {
                Task {
                    locationStore.fetchCityName(coordinateRegion, of: .selected)
                    plantFlag(coordinateRegion)
                    await generateSnapShot()
                    withAnimation {
                        isFlipped.toggle()
                    }
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
    
    public func CustomMapAnnotation(_ type: MapAnnotationType) -> some View {
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
    
    private func moveToUserLocation() {
        guard let coordinateRegion = locationStore.trackUserCoordinate(type: .get) else {
            return
        }
        self.coordinateRegion = coordinateRegion
    }
    
    private func plantFlag(_ coordinate: MKCoordinateRegion) {
        if annotationItems.count >= 1 {
            let _ = annotationItems.popLast()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            annotationItems.append(CustomAnnotationInfo(
                name: "현재 위치",
                description: "설명",
                latitude: coordinate.center.latitude,
                longitude: coordinate.center.longitude
            ))
        }
        
        locationStore.fetchCityName(coordinate, of: .selected)
    }
    
    private func configureSnapshotter() -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        
        options.region = coordinateRegion
        //MARK: 키보드가 올라오면 UIImage의 사이즈가 변경되는것을 막기 위해 -> 더 좋은 방법이 있으면 바꾸고 싶음
        options.size = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        options.scale = UIScreen.main.scale
        options.showsBuildings = true
        options.pointOfInterestFilter = .includingAll
        
        return options
    }
    
    @MainActor
    private func generateSnapShot() async {
        let options = configureSnapshotter()
        snapShotter = MKMapSnapshotter(options: options)
        
        guard let snapShotter = snapShotter else { return }
        
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        
        do {
            let snapshot = try await snapShotter.start()
            var point = snapshot.point(for: coordinateRegion.center)
            let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                snapshot.image.draw(at: .zero)
                
                let annotationView = MKPinAnnotationView(annotation: nil, reuseIdentifier: "annotation")
                
                let annotationImage = annotationView.image
                
                if rect.contains(point) {
                    point.x -= annotationView.bounds.width / 2
                    point.y -= annotationView.bounds.height / 2
                    point.x += annotationView.centerOffset.x
                    point.y += annotationView.centerOffset.y
                }
                
                annotationImage?.draw(at: point)
            }
            
            locationStore.updateLocationThumbnail(image)
        } catch {
            print(error.localizedDescription)
        }
    }
}

fileprivate struct CustomAnnotationInfo: Identifiable {
    let id: UUID = UUID()
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
                    .degrees(180) : .zero,
                                   axis: (x: 0, y: 1, z: 0)
                )
                .animation(.default, value: isFlipped)
        }
        
    }
}

#Preview {
    HistoryItemLocationEditView(locationStore: LocationStore(), isShowingSheet: .constant(false), coordinateRegion: .constant(MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: initialLatitude,
            longitude: initialLongitude
        ), latitudinalMeters: 500,
        longitudinalMeters: 500
    )))
}
