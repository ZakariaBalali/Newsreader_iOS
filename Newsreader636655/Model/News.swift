//
//  News.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

class News: Decodable, Identifiable, Equatable{
    let id: Int
    let feed: Int
    let title: String
    let summary: String
    let publishDate: String
    let image: String
    let url: String
    let related: [String]
    let categories: [Category]
    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case feed = "Feed"
        case title = "Title"
        case summary = "Summary"
        case publishDate = "PublishDate"
        case image = "Image"
        case url = "Url"
        case related = "Related"
        case categories = "Categories"
        case isLiked = "IsLiked"
    }
    
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Category: Decodable, Identifiable{
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
    }
}

