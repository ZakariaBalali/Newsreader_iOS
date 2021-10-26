//
//  BasicResponse.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

struct BasicResponse: Decodable {
    let results: [News]
    let nextId: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "Results"
        case nextId = "NextId"
    }
}
