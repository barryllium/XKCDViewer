//
//  NetworkViewModel.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI
import Network

// Class to track whether or not there is an active network connection
class NetworkViewModel: ObservableObject, @unchecked Sendable {
    @Published var isConnected = true
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                withAnimation {
                    self.isConnected = path.status == .satisfied
                }
            }
        }
        monitor.start(queue: queue)
    }
}
