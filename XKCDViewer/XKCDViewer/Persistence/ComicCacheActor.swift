//
//  ComicCacheActor.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation
import SwiftData

@available(iOS 17.0, *)
@ModelActor
actor ComicCacheActor: CacheActor {
    func fetchComic(for id: String) -> XKCDComic? {
        guard let intValue = Int(id) else { return nil }
        
        let fetchRequest = FetchDescriptor<XKCDComicData>(
            predicate: #Predicate { $0.number == intValue }
        )
        
        do {
            let data = try modelContext.fetch(fetchRequest)
            
            if let info = data.first {
                return info.getComic()
            }
        } catch {
            return nil
        }
        return nil
    }
    
    func add(_ comic: XKCDComic) throws {
        let number = comic.number
        let data = XKCDComicData(comic: comic)
        
        let fetchDescriptor = FetchDescriptor<XKCDComicData>(predicate: #Predicate { $0.number == number })
        
        if let _ = try modelContext.fetch(fetchDescriptor).first {
            return
        }
        
        modelContext.insert(data)

        try save()
    }
    
    func save() throws {
        try modelContext.save()
    }
}

@available(iOS 17.0, *)
extension ComicCacheActor {
    static func previewInstance() -> ComicCacheActor {
        let container = try! ModelContainer(for: XKCDComicData.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return ComicCacheActor(modelContainer: container)
    }
    
    static func instance() -> ComicCacheActor {
        let sharedModelContainer: ModelContainer = {
            let schema = Schema([XKCDComicData.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        return ComicCacheActor(modelContainer: sharedModelContainer)
    }
}
