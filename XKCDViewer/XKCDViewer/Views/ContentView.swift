//
//  ContentView.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: XKCDViewModel
    @State var comicNumber = ""
    
    init(cacheActor: CacheActor) {
        _viewModel = StateObject(wrappedValue: XKCDViewModel(cacheActor: cacheActor))
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(alignment: .center, spacing: 16) {
                NumberTextField(placeholder: "comic_number",
                                text: $comicNumber) {
                    loadComic()
                }
                                .accessibilityLabel(Text("comic_number_textfield"))
                                .font(.body)
                                .padding(8)
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1))
                                .frame(width: 160)
                
                Button {
                    loadComic()
                } label: {
                    let opacity = comicNumber.isEmpty ? 0.5 : 1
                    Text("load_comic")
                        .foregroundStyle(.white.opacity(opacity))
                        .font(.title3)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Capsule().foregroundStyle(Color.blue.opacity(opacity)))
                }
                .accessibilityLabel(Text("submit_comic_button"))
                .disabled(comicNumber.isEmpty)
                .navigationDestination(for: String.self) { number in
                    ComicDetailView(viewModel: viewModel, number: number)
                }
            }
            .padding()
            .navigationTitle("xkcd_viewer")
        }
    }
    
    func loadComic() {
        viewModel.loadComic(number: comicNumber)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            comicNumber = ""
        }
    }
}

#Preview {
    ContentView(cacheActor: NoCacheActor())
}
