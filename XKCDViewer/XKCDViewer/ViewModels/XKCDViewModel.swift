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
        
        withAnimation {
            isLoading = true
        }
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        let request = AsyncURLRequest<XKCDComic>(url: url)
        
        do {
            let result = try await apiClient.fetchURL(request)
            comic = result
        } catch NetworkError.notFound {
            showNotFoundMessage = true
        } catch {
            showAlert()
        }
    }
    
    func dismissComic() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
        errorAlertState = nil
        comic = nil
        showErrorAlert = false
    }
    
    func showAlert(state: AlertState = .generic) {
        errorAlertState = state
        showErrorAlert = true
    }
}

enum AlertState {
    case invalidURL
    case generic
}
