//
//  XKCDViewModel.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

class XKCDViewModel: ObservableObject {
    @Published var item: XKCDComic?
    @Published var showNotFoundAlert: Bool = false
    @Published var showInvalidURLAlert: Bool = false
    @Published var showGenericAlert: Bool = false
    
    var apiClient: APIClientProtocol = APIClient.default
    
    func fetchComic(number: String) async {
        guard let intValue = Int(number),
            let url = URL(string: "https://xkcd.com/\(intValue)/info.0.json") else {
            showInvalidURLAlert = true
            return
        }
        let request = AsyncURLRequest<XKCDComic>(url: url)
        
        do {
            let result = try await apiClient.fetchURL(request)
            item = result
        } catch NetworkError.notFound {
            showNotFoundAlert = true
        } catch {
            showGenericAlert = true
        }
    }
}
