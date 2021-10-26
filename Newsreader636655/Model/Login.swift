//
//  Login.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

struct Login: Encodable{
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "UserName"
        case password = "Password"
    }
}

struct LoginResponse: Decodable {
    let AuthToken: String
    
    enum CodingKeys: String, CodingKey {
        case AuthToken = "AuthToken"
    }
}
