//
//  XKCDViewModel.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

@MainActor
class XKCDViewModel: ObservableObject {
    @Published var comic: XKCDComic?
    @Published var showNotFoundMessage = false
    @Published var showErrorAlert = false
    @Published var errorAlertState: AlertState? = nil
    @Published var navigationPath: [String] = [] {
        didSet {
            if navigationPath.isEmpty {
                dismissComic()
            }
        }
    }
    @Published var isLoading = false
    
    var apiClient: APIClientProtocol = APIClient.default
    private let comicCacheActor: CacheActor
    
    init(cacheActor: CacheActor) {
        self.comicCacheActor = cacheActor
    }
    
    func loadComic(number: String) {
        showNotFoundMessage = false
        navigationPath.append(number)
    }
    
    func fetchComic(number: String) async {
        guard let intValue = Int(number),
            let url = URL(string: "https://xkcd.com/\(intValue)/info.0.json") else {
            showAlert(state: .invalidURL)
            return
        }
        
        // Show a loading spinner when we have a valid url
        withAnimation {
            isLoading = true
        }
        
        // When this function exits, we always want to hide the loading spinner
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        // If SwiftData is available, check the cache. If we have the data, load and exit without calling network
        if #available(iOS 17, *),
           let cachedComic = await comicCacheActor.fetchComic(for: number) {
            comic = cachedComic
            return
        }
        
        // Create the network request to load asynchronously
        let request = AsyncURLRequest<XKCDComic>(url: url)
        
        do {
            let result = try await apiClient.fetchURL(request)
            comic = result
            // If SwiftData is available, cache the response
            if #available(iOS 17, *) {
                try? await comicCacheActor.add(result)
            }
        } catch NetworkError.notFound {
            showNotFoundMessage = true
        } catch {
            showAlert()
        }
    }
    
    // Whenever the ComicDetailView is dismissed, we want to reset it so we don't show stale data on the next load
    func dismissComic() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
        errorAlertState = nil
        comic = nil
        showErrorAlert = false
    }
    
    // Show either the generic or invalid URL alert
    func showAlert(state: AlertState = .generic) {
        errorAlertState = state
        showErrorAlert = true
    }
}

enum AlertState {
    case invalidURL
    case generic
}
