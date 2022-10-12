//
//  ContentViewModel.swift
//  GeneralMagicPOC
//
//  Created by Niclas Raabe on 10.10.22.
//

import CoreLocation
import Foundation
import GEMKit

let GEMToken = "<TOKEN>"
let locationManager = CLLocationManager()

class ContentViewModel: NSObject, ObservableObject {
    var mapViewController: MapViewController!
    var navigationContext: NavigationContext!
    var positionContext: PositionContext!
    var dataSource: DataSourceContext!
    
    @Published var route: RouteObject?
    
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        
        intializeSDK()
        setupDataSource()
    }
    
    func intializeSDK() {
        let success = GEMSdk.shared().initSdk(GEMToken)
        
        if success {
            GEMSdk.shared().setUnitSystem(.metric)
        }

        NSLog("GEMKit init with success:%@", String(success))
    }
    
    func setupDataSource() {
        let configuration = DataSourceConfigurationObject()
        configuration.setPositionActivity(.otherNavigation)
        configuration.setPositionAccuracy(.whenMoving)
        configuration.setPositionDistanceFilter(0)
        
        dataSource = DataSourceContext()
        dataSource!.setConfiguration(configuration, for: .position)
        
        positionContext = PositionContext(context: dataSource!)
    }
    
    func onAppear() {
        mapViewController = .init()
        mapViewController.hideCompass()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mapViewController.startRender()
            self.mapViewController.startFollowingPosition(withAnimationDuration: 1000, zoomLevel: -1, viewAngle: 0) { _ in }
        }
        
        calculateRoute()
        
        objectWillChange.send()
    }
    
    func calculateRoute() {
        let preferences = RoutePreferencesObject()
        preferences.setTransportMode(.bicycle)
        
        navigationContext = NavigationContext(preferences: preferences)
        navigationContext?.delegate = self
        
        let waypoints: [LandmarkObject] = Constants.routeCoordinates.map { coordinate in
            LandmarkObject.landmark(withName: "\(coordinate)", location: .coordinates(withLatitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        NSLog("Calculating route...")
        navigationContext.calculateRoute(withWaypoints: waypoints, completionHandler: { (results: [RouteObject]) in
            NSLog("Found %d routes.", results.count)

            for route in results {
                if let timeDuration = route.getTimeDistance() {
                    let time = timeDuration.getTotalTimeFormatted() + timeDuration.getTotalTimeUnitFormatted()
                    let distance = timeDuration.getTotalDistanceFormatted() + timeDuration.getTotalDistanceUnitFormatted()

                    NSLog("route time:%@, distance:%@", time, distance)
                }
            }
            if let route = results.first {
                self.route = route
                self.mapViewController.showRoutes([route], withTraffic: nil, showSummary: false)
            }
        })
    }
    
    func startNavigation() {
        guard let route = route else {
            return
        }
        navigationContext!.navigate(withRoute: route) { _ in }
    }
}

// MARK: - NavigationContextDelegate

extension ContentViewModel: NavigationContextDelegate {
    func navigationContext(_ navigationContext: NavigationContext, route: RouteObject, navigationStatusChanged status: NavigationStatus) {
        NSLog("navigationStatusChanged: \(status)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, navigationStartedForRoute route: RouteObject) {
        NSLog("navigationStartedForRoute: \(route)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, navigationInstructionUpdatedForRoute route: RouteObject) {
        NSLog("navigationInstructionUpdatedForRoute: \(route)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, navigationRouteUpdated route: RouteObject) {
        NSLog("navigationRouteUpdated: \(route)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, route: RouteObject, navigationWaypointReached waypoint: LandmarkObject) {
        NSLog("navigationWaypointReached: \(waypoint)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, route: RouteObject, navigationDestinationReached waypoint: LandmarkObject) {
        NSLog("navigationDestinationReached: \(waypoint)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, route: RouteObject, navigationError code: Int) {
        NSLog("navigationError: \(code)")
    }
    
    func navigationContext(_ navigationContext: NavigationContext, canPlayNavigationSoundForRoute route: RouteObject) -> Bool {
        return false
    }
    
    func navigationContext(_ navigationContext: NavigationContext, route: RouteObject, navigationSound sound: SoundObject) {}
    
    func navigationContext(_ navigationContext: NavigationContext, onBetterRouteDetected route: RouteObject, travelTime: Int, delay: Int, timeGain: Int) {}
    
    func navigationContext(_ navigationContext: NavigationContext, onBetterRouteInvalidated state: Bool) {}
}

enum Constants {
    static let routeCoordinates: [CLLocationCoordinate2D] = [.init(latitude: 51.32624430087813, longitude: 9.447682602603694),
                                                             .init(latitude: 51.32771612680204, longitude: 9.44803543463846),
                                                             .init(latitude: 51.327625555217715, longitude: 9.450186625875896),
                                                             .init(latitude: 51.32584558532012, longitude: 9.45111467019165),
                                                             .init(latitude: 51.326086941217106, longitude: 9.448759690741458)]
}
