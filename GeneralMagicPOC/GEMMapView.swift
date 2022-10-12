//
//  GEMMapView.swift
//  GpxRoute
//
//  Created by Niclas Raabe on 11.10.22.
//

import GEMKit
import SwiftUI

struct GEMMapView: UIViewControllerRepresentable {
    var viewModel: ContentViewModel
    
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: Context) -> MapViewController {
        return viewModel.mapViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {}
    
    public static func dismantleUIViewController(_ uiViewController: MapViewController, coordinator: Self.Coordinator) {}
}
