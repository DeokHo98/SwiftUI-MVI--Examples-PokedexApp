//
//  MockTaskWrapper.swift
//  Pokedex-MVITests
//
//  Created by Jeong Deokho on 9/23/24.
//

import Foundation
import XCTest
@testable import Pokedex_MVI

class MockTaskWrapper: TaskWrapper {
    var runHandler: (() -> Void)?
    
    func run<T>(_ operation: @escaping () async throws -> T) -> Task<T, Error> {
        return Task { 
            let result = try await operation()
            runHandler?()
            return result
        }
    }
    
}
