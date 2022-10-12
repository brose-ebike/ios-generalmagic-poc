//
//  ContentView.swift
//  GeneralMagicPOC
//
//  Created by Niclas Raabe on 10.10.22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            if viewModel.mapViewController != nil {
                GEMMapView(viewModel: viewModel)
                    .ignoresSafeArea()
            }
            if viewModel.route != nil {
                Button("Start") {
                    viewModel.startNavigation()
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
