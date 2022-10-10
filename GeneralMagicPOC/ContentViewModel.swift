//
//  ContentViewModel.swift
//  GeneralMagicPOC
//
//  Created by Niclas Raabe on 10.10.22.
//

import Foundation
import GEMKit

let GEMToken = "<TOKEN>"

class ContentViewModel: NSObject {
    var navigationContext: NavigationContext!
    let dispatchQueue = DispatchQueue(label: "SDK.InitializeQueue")
    
    override init() {
        super.init()
        
        //dispatchQueue.async {
            self.intializeSDK()
        //}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.startNavigationWithGPX()
        }
    }
    
    func intializeSDK() {
        let success = GEMSdk.shared().initSdk(GEMToken)
        
        if success {
            GEMSdk.shared().setUnitSystem(.metric)
        }

        NSLog("GEMKit init with success:%@", String(success))
    }
    
    // No answer of navigationContext.calculateRoute...
    func startNavigationWithGPX() {
        guard let fileURL = Bundle.main.url(forResource: "circle", withExtension: "gpx") else {
            assertionFailure()
            return
        }
        guard let data = NSData(contentsOf: fileURL) as Data? else {
            assertionFailure()
            return
        }
        
        let preferences = RoutePreferencesObject()
        preferences.setTransportMode(.bicycle)
        
        navigationContext = NavigationContext(preferences: preferences)
        navigationContext?.delegate = self
        
        let startPoints: [LandmarkObject] = []
        let endPoints: [LandmarkObject] = []
        
        NSLog("Calculating route...")
        navigationContext.calculateRoute(withStartWaypoints: startPoints,
                                         buffer: data,
                                         endWaypoints: endPoints,
                                         completionHandler: { (results: [RouteObject]) in
                                             NSLog("Found %d routes.", results.count)
            
                                             for route in results {
                                                 if let timeDuration = route.getTimeDistance() {
                                                     let time = timeDuration.getTotalTimeFormatted() + timeDuration.getTotalTimeUnitFormatted()
                                                     let distance = timeDuration.getTotalDistanceFormatted() + timeDuration.getTotalDistanceUnitFormatted()
                    
                                                     NSLog("route time:%@, distance:%@", time, distance)
                                                 }
                                             }
                                         })
    }
    
    // No answer of navigationContext.calculateRoute...
    func startNavigationWithWaypoints() {
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
        })
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
    static let routeCoordinates: [CLLocationCoordinate2D] = [.init(latitude: 40.74163612569854, longitude: -73.99374403493513),
                                                             .init(latitude: 40.74293079743917, longitude: -73.99281050186207),
                                                             .init(latitude: 40.74155114227432, longitude: -73.98958552778382),
                                                             .init(latitude: 40.74221690595822, longitude: -73.98907105362191),
                                                             .init(latitude: 40.742824910521236, longitude: -73.98860362553543),
                                                             .init(latitude: 40.74346951687277, longitude: -73.98816932142395),
                                                             .init(latitude: 40.743116374662996, longitude: -73.98740816778515),
                                                             .init(latitude: 40.74276232589619, longitude: -73.9865921825232),
                                                             .init(latitude: 40.74188782900569, longitude: -73.98730475449612),
                                                             .init(latitude: 40.74087248138878, longitude: -73.98800830150036),
                                                             .init(latitude: 40.740204586123006, longitude: -73.98638537083042),
                                                             .init(latitude: 40.739546964090394, longitude: -73.98475718903514),
                                                             .init(latitude: 40.74019992129571, longitude: -73.98427464539485),
                                                             .init(latitude: 40.740782371079156, longitude: -73.9837959992614),
                                                             .init(latitude: 40.74050763125072, longitude: -73.98309978670369),
                                                             .init(latitude: 40.740133983262986, longitude: -73.98220051214996),
                                                             .init(latitude: 40.738886643164726, longitude: -73.98315780441682),
                                                             .init(latitude: 40.737952496491005, longitude: -73.98088786136883),
                                                             .init(latitude: 40.73858442065284, longitude: -73.98040196284998),
                                                             .init(latitude: 40.73757883413092, longitude: -73.97807400211008),
                                                             .init(latitude: 40.73567202450648, longitude: -73.9795607060094),
                                                             .init(latitude: 40.738251295313496, longitude: -73.98569407715556),
                                                             .init(latitude: 40.73892510776117, longitude: -73.98733508003534),
                                                             .init(latitude: 40.73985374590963, longitude: -73.98957601420553),
                                                             .init(latitude: 40.741397784191776, longitude: -73.98914813357109),
                                                             .init(latitude: 40.74293079743917, longitude: -73.99281050186207),
                                                             .init(latitude: 40.74163612569854, longitude: -73.99374403493513)]
}
