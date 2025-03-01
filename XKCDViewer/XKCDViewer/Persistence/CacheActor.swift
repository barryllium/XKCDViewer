//
//  CacheActor.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation

protocol CacheActor {
    func fetchComic(for id: String) async -> XKCDComic?
    func add(_ comic: XKCDComic) async throws
}

actor NoCacheActor: CacheActor {
    func fetchComic(for id: String) -> XKCDComic? { return nil }
    
    func add(_ comic: XKCDComic) throws {}
}
