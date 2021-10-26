//
//  FavoriteListView.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

import SwiftUI

struct FavoriteListView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    
    var body: some View {
        if LoginViewModel.loginVM.isAuthenticated {
            
            if newsViewModel.nextIdForLikedArticles == -1 {
                ProgressView("Loading")
                    .onAppear {
                        newsViewModel.fetchLikedArticles { result in
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
            } else if (newsViewModel.nextIdForLikedArticles != -1 && !newsViewModel.likedNewsArticles.isEmpty){
                ScrollView {
                    LazyVStack {
                        ForEach(newsViewModel.likedNewsArticles) { news in
                            NavigationLink(destination: NewsDetailView(newsViewModel: newsViewModel, news: news).navigationTitle("Details")) {
                                NewsCell(newsViewModel: newsViewModel, news: news)
                            }.foregroundColor(.black)
                        }
                    }
                }
            } else {
                Text("Empty")
            }
        } else {
            Text("Login to see your favorites")
        }
        
    }
}

