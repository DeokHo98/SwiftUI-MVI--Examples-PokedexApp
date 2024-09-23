//
//  MockCoordinator.swift
//  Pokedex-MVITests
//
//  Created by Jeong Deokho on 9/23/24.
//

import SwiftUI
@testable import Pokedex_MVI

final class MockCoordinator: CoordinatorDependency {
    var path: NavigationPath = NavigationPath()
    var pushDestination: [AppDestination] = []
    var popedCount = 0
    
    func push(destination: AppDestination) {
        pushDestination.append(destination)
    }
    
    func pop() {
        popedCount += 1
    }
}
