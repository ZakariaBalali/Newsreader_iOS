//
//  NewsViewModel.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Combine
import SwiftUI

class NewsViewModel: ObservableObject {
    @Published var newsArticles: [News] = []
    @Published var images = [String : Data]()
    @Published var likedNewsArticles: [News] = []
    @Published var response: String = ""
    @Published var nextIdForLikedArticles: Int = -1
    @Published var isLoadingPage = false
    private var nextId: Int = 0
    private var currentPage = 1
    private var canLoadMorePages = true
    var cancellationToken = Set<AnyCancellable>()
}

extension NewsViewModel {
    
    func fetchNewsArticles(completion: @escaping (Result<BasicResponse, RequestError>) -> Void) {
        NewsAPI.shared.fetchNewsArticles(requestType: .get, endpoint: .newsArticles)?
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
            }, receiveValue: { (response) in
                self.nextId = response.nextId
                self.newsArticles = response.results
                self.fetchImages(of: self.newsArticles)
                completion(.success(response))
            })
            .store(in: &cancellationToken)
        
    }
    
    func fetchMoreNewsArticles(currentArticle news: News?,completion: @escaping (Result<BasicResponse, RequestError>) -> Void) {
        
        guard let news = news else {
            fetchNewsArticles {_ in}
            return
        }
        
        let thresholdIndex = newsArticles.index(newsArticles.endIndex, offsetBy: -5)
        if newsArticles.firstIndex(where: { $0.id == news.id }) == thresholdIndex {
            
            guard !isLoadingPage && canLoadMorePages else {
                return
            }
            
            isLoadingPage = true
            
            NewsAPI.shared.fetchNextNewsArticles(requestType: .get, endpoint: .nextNewsArticles(nextId))?
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
                }, receiveValue: { (response) in
                    self.nextId = response.nextId
                    self.isLoadingPage = false
                    self.currentPage += 1
                    self.newsArticles.append(contentsOf: response.results)
                    self.fetchImages(of: self.newsArticles)
                    completion(.success(response))
                })
                .store(in: &cancellationToken)
            
        }
    }
    
    func fetchImages(of newsArticles: [News]) {
        newsArticles.forEach { news in
            NewsAPI.shared.getImage(for: news){ result in
                switch result {
                    case .success(let image):
                        if !self.images.keys.contains(news.image) {
                            self.images[news.image] = image
                        }
                    case .failure(let error):
                        switch error {
                            case .urlError(let urlError):
                                print(urlError)
                            case .decodingError(let decodingError):
                                print(decodingError)
                            case .genericError(let error):
                                print(error)
                        }
                }
            }
        }
    }
    
    func fetchLikedArticles(completion: @escaping (Result<BasicResponse, RequestError>) -> Void) {
        NewsAPI.shared.fetchLikedNewsArticles(requestType: .get, endpoint: .likedNewsArticles)?
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
                self.likedNewsArticles = result.results
                self.nextIdForLikedArticles = result.nextId
                self.fetchImages(of: self.likedNewsArticles)
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func likeAnArticle(news: News, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        NewsAPI.shared.likeNewsArticle(requestType: .put, endpoint: .likeNewsArtcile(news.id))?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                self.likedNewsArticles.append(news)
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                self.likedNewsArticles.append(news)
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
    func unLikeAnArticle(news: News, completion: @escaping (Result<Data, RequestError>) -> Void) {
        
        NewsAPI.shared.likeNewsArticle(requestType: .delete, endpoint: .unlikeNewsArticle(news.id))?
            .sink(receiveCompletion: { result in
                switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        switch error {
                            case let urlError as URLError:
                                completion(.failure(.urlError(urlError)))
                            case let decodingError as DecodingError:
                                self.likedNewsArticles.removeAll(where: {$0.id == news.id})
                            self.newsArticles.first(where: {$0 == news})?.isLiked.toggle()
                                completion(.failure(.decodingError(decodingError)))
                            default:
                                completion(.failure(.genericError(error)))
                        }
                }
            }, receiveValue: { result in
                self.likedNewsArticles.removeAll(where: {$0.id == news.id})
                self.newsArticles.first(where: {$0 == news})?.isLiked.toggle()
                completion(.success(result))
            })
            .store(in: &cancellationToken)
    }
    
}

