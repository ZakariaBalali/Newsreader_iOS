//
//  LikeViewModel.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

struct LikeViewModel {
    
    static func likeAnArticle(news: News, newsViewModel: NewsViewModel) {
        news.isLiked.toggle()
        newsViewModel.likeAnArticle(news: news) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                switch error {
                case .urlError(let urlError):
                    print("URL Error: \(String(describing: urlError))")
                case .decodingError(let decodingError):
                    print("Decoding Error: \(String(describing: decodingError))")
                case .genericError(let error):
                    print("Error: \(String(describing: error))")
                }
            }
        }
    }
    
    static func unLikeAnArticle(news: News, newsViewModel: NewsViewModel) {
        news.isLiked.toggle()
        newsViewModel.unLikeAnArticle(news: news) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                switch error {
                case .urlError(let urlError):
                    print("URL Error: \(String(describing: urlError))")
                case .decodingError(let decodingError):
                    print("Decoding Error: \(String(describing: decodingError))")
                case .genericError(let error):
                    print("Error: \(String(describing: error))")
                }
            }
        }
    }
}
