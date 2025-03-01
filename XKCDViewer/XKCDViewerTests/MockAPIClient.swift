//
//  MockAPIClient.swift
//  XKCDViewerTests
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation
@testable import XKCDViewer

final class MockAPIClient: APIClientProtocol {
    func fetchURL<T>(_ request: AsyncURLRequest<T>) async throws -> T where T : Decodable {
        if request.urlRequest.url?.absoluteString.contains("1000000") == true {
            throw NetworkError.notFound
        } else {
            let data = Bundle.main.decode(XKCDComic.self, from: .item100)
            return try JSONDecoder().decode(T.self, from: JSONEncoder().encode(data))
        }
    }
}
