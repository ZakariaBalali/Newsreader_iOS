//
//  NewsDetailView.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import SwiftUI

struct NewsDetailView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    let news: News
    @State var isLiked: Bool = false

    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    if !newsViewModel.images.isEmpty {
                        if let image = newsViewModel.images[news.image] {
                            if let uiImage = UIImage(data: image){
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
    
                            }
                        }
                    }else{
                        if let uiImage = UIImage(systemName: "person.fill"){
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    if LoginViewModel.loginVM.isAuthenticated {
                        HStack() {
                            if isLiked {
                                Button(action: {
                                    isLiked.toggle()
                                    LikeViewModel.unLikeAnArticle(news: news, newsViewModel: newsViewModel)
                                }, label: {Image(systemName: "star.fill").foregroundColor(.red)})
                            } else {
                                Button(action: {
                                    isLiked.toggle()
                                    LikeViewModel.likeAnArticle(news: news, newsViewModel: newsViewModel)
                                }, label: {Image(systemName: "star").foregroundColor(.black)})
                            }
                        }.padding(10)
                            .background(Color.white)
                            .cornerRadius(20)
                            .position(x: 30, y: 340)
                    }
                }
                
                Text(news.title)
                    .font(Font.headline.weight(.bold))
                    .padding(2)
                
                Text(news.publishDate)
                    .font(.footnote)
                
                Text(news.summary)
                    .padding(2)
                
                HStack {
                    Link("View in Browser",
                         destination: URL(string: news.url)!)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundColor(.white)
                        .background(Color.init(.blue))
                        .padding(2)
                }
                
            }
        }.onAppear{
            isLiked = news.isLiked
        }.navigationBarItems(trailing: Button(action: share) {
            Text("Share")
        })

    }
    
    func share() {
        guard let data = URL(string: news.url) else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
}

