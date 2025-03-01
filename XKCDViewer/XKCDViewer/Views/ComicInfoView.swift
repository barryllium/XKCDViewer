//
//  ComicInfoView.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

struct ComicInfoView: View {
    var comic: XKCDComic
    @State var isShowingAltText = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .center, spacing: 16) {
                    Text(comic.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button {
                        withAnimation {
                            self.isShowingAltText.toggle()
                        }
                    } label: {
                        AsyncImage(url: URL(string: comic.image)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Image(.comicPlaceholder)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                        .accessibilityLabel(comic.transcript)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Text(comic.date ?? "")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    
                    Spacer()
                }
                
                // Show an "invisible" overlay over the rest of the view, so tapping on it can dismiss the alt text
                if isShowingAltText {
                    Color.secondary.opacity(0.00001)
                        .onTapGesture {
                            withAnimation {
                                isShowingAltText = false
                            }
                        }
                }
                
                VStack {
                    Spacer()
                    Text(comic.alt)
                        .padding(24)
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.black.opacity(0.9)))
                        .offset(y: isShowingAltText ? 0 : geometry.size.height)
                }
            }
        }
    }
}

#Preview {
    let data = Bundle.main.decode(XKCDComic.self, from: .item100)
    ComicInfoView(comic: try! JSONDecoder().decode(XKCDComic.self, from: JSONEncoder().encode(data)))
}
