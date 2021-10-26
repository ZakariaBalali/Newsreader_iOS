//
//  NewsListView.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    @State private var selected = 0
    
    var body: some View {
        if newsViewModel.newsArticles.isEmpty {
            ProgressView("Loading")
                .onAppear(){
                    newsViewModel.fetchNewsArticles { result in
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
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(newsViewModel.newsArticles) { news in
                        NavigationLink(destination: NewsDetailView(newsViewModel: newsViewModel, news: news).navigationTitle("Detail")) {
                            NewsCell(newsViewModel: newsViewModel, news: news)
                                .onAppear {
                                    newsViewModel.fetchMoreNewsArticles(currentArticle: news) { result in
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
                        .foregroundColor(.black)                    }
                    
                    if newsViewModel.isLoadingPage {
                        ProgressView()
                    }
                }
            }
        }
    }
}


