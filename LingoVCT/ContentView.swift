//
//  ContentView.swift
//  LingoVCT
//
//  Created by Mukhammad Bustonov on 10/12/24.
//

import SwiftUI

struct ContentView: View {
//    @State private var selectedIcon: String = "mic"
    var body: some View {
        VStack {
            Spacer()
            
            // Main Content
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
           
            Spacer()
        }
    }
}


#Preview {
    ContentView()
}
