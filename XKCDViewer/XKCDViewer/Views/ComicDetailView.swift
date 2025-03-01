//
//  ComicDetailView.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

struct ComicDetailView: View {
    @ObservedObject var viewModel: XKCDViewModel
    var number: String
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.showNotFoundMessage {
                Text("invalid_comic \(number)")
                    .font(.headline)
            } else if let comic = viewModel.comic {
                ComicInfoView(comic: comic)
            }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("error"),
                  message: Text(viewModel.errorAlertState == .invalidURL ? "invalid_url_error" : "generic_error"),
                  dismissButton: .default(Text("ok"), action: {
                viewModel.dismissComic()
            }))
        }
        .padding(.horizontal, 16)
        .task {
            await viewModel.fetchComic(number: number)
        }
    }
}

#Preview {
    ComicDetailView(viewModel: XKCDViewModel(), number: "100")
}
