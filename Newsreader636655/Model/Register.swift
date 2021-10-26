//
//  Register.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

struct RegisterResponse: Decodable {
    let success: Bool
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case message = "Message"
    }
}
