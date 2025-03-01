//
//  XKCDViewerApp.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

@main
struct XKCDViewerApp: App {
    var body: some Scene {
        var cacheActor: CacheActor
        if #available(iOS 17, *) {
            cacheActor = ComicCacheActor.instance()
        } else {
            cacheActor = NoCacheActor()
        }
        
        return WindowGroup {
            ContentView(cacheActor: cacheActor)
                .environmentObject(NetworkViewModel())
        }
    }
}
