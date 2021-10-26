//
//  EndpointsLogic.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation
import Combine

struct BaseURL {
    static let url = "https://inhollandbackend.azurewebsites.net/api/"
}

protocol EndpointsLogic {
    
    func register(requestType: RequestType, endpoint: EndpointType, login: Login) -> AnyPublisher<RegisterResponse, Error>?
    
    func login(requestType: RequestType, endpoint: EndpointType, login: Login) -> AnyPublisher<LoginResponse, Error>?
    
    func fetchNewsArticles(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<BasicResponse, Error>?
    
    func fetchNextNewsArticles(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<BasicResponse, Error>?
    
    func fetchLikedNewsArticles(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<BasicResponse, Error>?
    
    func likeNewsArticle(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<Data, Error>?
    
    func unLikeNewsArticle(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<Data, Error>?
}


enum EndpointType{
    case newsArticles
    case nextNewsArticles(Int)
    case likedNewsArticles
    case likeNewsArtcile(Int)
    case unlikeNewsArticle(Int)
    case register
    case login
    
    var urlExtension: String {
        switch self {
            case .newsArticles:
                return "Articles"
            case .nextNewsArticles(let id):
                return "Articles/\(id)"
            case .likedNewsArticles:
                return "Articles/liked"
            case .likeNewsArtcile(let id):
                return "Articles/\(id)/like"
            case .unlikeNewsArticle(let id):
                return "Articles/\(id)/like"
            case .register:
                return "Users/register"
            case .login:
                return "Users/login"
        }
    }
}

enum RequestError: Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case genericError(Error)
}

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

