//
//  GeneralMagicPOCApp.swift
//  GeneralMagicPOC
//
//  Created by Niclas Raabe on 10.10.22.
//

import SwiftUI

@main
struct GeneralMagicPOCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
