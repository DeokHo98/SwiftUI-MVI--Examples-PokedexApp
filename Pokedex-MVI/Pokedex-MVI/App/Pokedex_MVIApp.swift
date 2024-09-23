//
//  Pokedex_MVIApp.swift
//  Pokedex-MVI
//
//  Created by Jeong Deokho on 9/12/24.
//

import SwiftUI

@main
struct Pokedex_MVIApp: App {
    
    @State private var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                DexView(viewModel: DexViewModel(coordinator: coordinator))
                    .navigationDestination(for: AppDestination.self) { destination in
                        coordinator.showScene(destination: destination)
                    }
            }
            .accentColor(.black)
        }
    }
}
