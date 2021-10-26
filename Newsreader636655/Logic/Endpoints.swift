//
//  Endpoints.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation
import Combine

class NewsAPI: EndpointsLogic {
    static let shared = NewsAPI()
    private var cancellable = Set<AnyCancellable>()
    private init() {}
    
    func execute<ResponseType: Decodable>(request: URLRequest) -> AnyPublisher<ResponseType, Error>{
        URLSession.shared.dataTaskPublisher(for: request)
            .map({$0.data})
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchNewsArticles(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<BasicResponse, Error>? {
        let urlString = BaseURL.url + endpoint.urlExtension
        guard let url = URL(string: urlString) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        if LoginViewModel.loginVM.isAuthenticated {
            requestURL.setValue(LoginViewModel.loginVM.accessToken, forHTTPHeaderField: "x-authtoken")
        }
        requestURL.httpMethod = requestType.rawValue
        
        return execute(request: requestURL)
    }
    
    
    func getImage(for news: News, completion: @escaping (Result<Data, RequestError>) -> Void){
        let url = URL(string: news.image)!
        let requestURL = URLRequest(url: url)
        URLSession.shared.dataTaskPublisher(for: requestURL)
            .map({$0.data})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        completion(.failure(.urlError(error)))
                }
            }) { (image) in
                completion(.success(image))
            }
            .store(in: &cancellable)
    }
    
    func fetchNextNewsArticles(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<BasicResponse, Error>?{
        let urlString = BaseURL.url + endpoint.urlExtension + "?count=20"
        guard let url = URL(string: urlString) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        if LoginViewModel.loginVM.isAuthenticated {
            requestURL.setValue(LoginViewModel.loginVM.accessToken, forHTTPHeaderField: "x-authtoken")
        }
        requestURL.httpMethod = requestType.rawValue
        
        return execute(request: requestURL)
    }
    
    func fetchLikedNewsArticles(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<BasicResponse, Error>?{
        let urlString = BaseURL.url + endpoint.urlExtension
        guard let url = URL(string: urlString) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        requestURL.setValue(LoginViewModel.loginVM.accessToken, forHTTPHeaderField: "x-authtoken")
        requestURL.httpMethod = requestType.rawValue
        
        return execute(request: requestURL)
    }
    
    func likeNewsArticle(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<Data, Error>?{
        let stringURL = BaseURL.url + endpoint.urlExtension
        guard let url = URL(string: stringURL) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        requestURL.setValue(LoginViewModel.loginVM.accessToken, forHTTPHeaderField: "x-authtoken")
        requestURL.httpMethod = requestType.rawValue
        
        return execute(request: requestURL)
    }
    
    func unLikeNewsArticle(requestType: RequestType, endpoint: EndpointType) -> AnyPublisher<Data, Error>?{
        let stringURL = BaseURL.url + endpoint.urlExtension
        guard let url = URL(string: stringURL) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        requestURL.setValue(LoginViewModel.loginVM.accessToken, forHTTPHeaderField: "x-authtoken")
        requestURL.httpMethod = requestType.rawValue
        
        return execute(request: requestURL)
    }
    
    func register(requestType: RequestType, endpoint: EndpointType, login: Login) -> AnyPublisher<RegisterResponse, Error>?{
        
        let stringURL = BaseURL.url + endpoint.urlExtension
        guard let url = URL(string: stringURL) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.httpMethod = requestType.rawValue
        guard let body = try? JSONEncoder().encode(login) else { return nil }
        requestURL.httpBody = body
        
        return execute(request: requestURL)
    }
    
    func login(requestType: RequestType, endpoint: EndpointType, login: Login) -> AnyPublisher<LoginResponse, Error>?{
        
        let stringURL = BaseURL.url + endpoint.urlExtension
        guard let url = URL(string: stringURL) else {
            return nil
        }
        var requestURL = URLRequest(url: url)
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestURL.httpMethod = requestType.rawValue
        guard let body = try? JSONEncoder().encode(login) else { return nil }
        requestURL.httpBody = body
        
        return execute(request: requestURL)
    }
    
    
}
