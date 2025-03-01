//
//  XKCDComicData.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation
import SwiftData

// Base class to save XKCDComic instance data to SwiftData
@available(iOS 17.0, *)
@Model
class XKCDComicData {
    var month: String
    @Attribute(.unique) var number: Int
    var link: String
    var year: String
    var news: String
    var safeTitle: String
    var transcript: String
    var alt: String
    var image: String
    var title: String
    var day: String
    
    init(comic: XKCDComic) {
        self.month = comic.month
        self.number = comic.number
        self.link = comic.link
        self.year = comic.year
        self.news = comic.news
        self.safeTitle = comic.safeTitle
        self.transcript = comic.transcript
        self.alt = comic.alt
        self.image = comic.image
        self.title = comic.title
        self.day = comic.day
    }
    
    func getComic() -> XKCDComic {
        return XKCDComic(month: self.month,
                         number: self.number,
                         link: self.link,
                         year: self.year,
                         news: self.news,
                         safeTitle: self.safeTitle,
                         transcript: self.transcript,
                         alt: self.alt,
                         image: self.image,
                         title: self.title,
                         day: self.day)
    }
}
