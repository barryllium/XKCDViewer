//
//  NetworkError.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case notFound
    case other
}

extension LocalizedError {
    var errorDescription: String? {
        return "\(self)"
    }
}
