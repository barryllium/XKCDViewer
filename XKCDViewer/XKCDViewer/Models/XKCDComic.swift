//
//  XKCDComic.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import Foundation

// Base struct for parsing json and driving ComicDetailView
struct XKCDComic: Codable {
    let month: String
    let number: Int
    let link: String
    let year: String
    let news: String
    let safeTitle: String
    let transcript: String
    let alt: String
    let image: String
    let title: String
    let day: String
    
    static func urlString(for comicNumber: Int) -> String {
        "https://xkcd.com/\(comicNumber)/info.0.json"
    }
    
    enum CodingKeys: String, CodingKey {
        case month
        case number = "num"
        case link
        case year
        case news
        case safeTitle = "safe_title"
        case transcript
        case alt
        case image = "img"
        case title
        case day
    }
    
    var date: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        
        if let date = dateFormatter.date(from: "\(year) \(month) \(day)") {
            return date.formatted(date: .long, time: .omitted)
        }
        
        return nil
    }
}
