//
//  ContentView.swift
//  GeneralMagicPOC
//
//  Created by Niclas Raabe on 10.10.22.
//

import SwiftUI

struct ContentView: View {
    var viewModel: ContentViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
