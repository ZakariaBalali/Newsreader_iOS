//
//  UserViewModel.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation
import Combine
import KeychainAccess

final class LoginViewModel: ObservableObject {
    
    static let loginVM = LoginViewModel()
    @Published var isAuthenticated: Bool = false
    var cancellationToken = Set<AnyCancellable>()
    private let keychain = Keychain()
    private var accessTokenKeyChainKey = "accessToken"
    
    var accessToken: String? {
        get {
            try? keychain.get(accessTokenKeyChainKey)
        }
        set(newValue) {
            guard let accessToken = newValue else {
                try? keychain.remove(accessTokenKeyChainKey)
                isAuthenticated = false
                return
            }
            try? keychain.set(accessToken, key: accessTokenKeyChainKey)
            isAuthenticated = true
        }
    }
    
    init() {
        isAuthenticated = accessToken != nil
    }
}

extension LoginViewModel {
    
    func login(for login: Login, completion: @escaping (Result<LoginResponse, RequestError>) -> Void) {
        NewsAPI.shared.login(requestType: .post, endpoint: .login, login: login)?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case.failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            } , receiveValue: { result in
                self.accessToken = result.AuthToken
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func register(login: Login, completion: @escaping (Result<RegisterResponse, RequestError>) -> Void) {
        NewsAPI.shared.register(requestType: .post, endpoint: .register, login: login)?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func logout() {
        accessToken = nil
    }
}

