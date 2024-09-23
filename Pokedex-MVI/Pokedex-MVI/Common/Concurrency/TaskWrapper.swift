//
//  TaskWrapper.swift
//  Pokedex-MVI
//
//  Created by Jeong Deokho on 9/23/24.
//

import Foundation

protocol TaskWrapper {
    @discardableResult
    func run<T>(_ operation: @escaping () async throws -> T) -> Task<T, Error>
}

struct RealTaskWrapper: TaskWrapper {
    func run<T>(_ operation: @escaping () async throws -> T) -> Task<T, Error> {
        return Task { try await operation() }
    }
}
