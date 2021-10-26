//
//  NewsCell.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation
import SwiftUI

struct NewsCell: View {
    @ObservedObject var newsViewModel: NewsViewModel
    @State var isLiked: Bool = false
    let news: News
    
    var body: some View {
        VStack{
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                if let image = newsViewModel.images[news.image] {
                    if let uiImage = UIImage(data: image){
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.size.width - 40, height: 175, alignment: .center)
                            .clipped()
                            
                    }
                }else{
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width - 40, height: 175, alignment: .center)
                        .clipped()
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
                            }, label: {Image(systemName: "star")})
                        }
                    }.padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .position(x:UIScreen.main.bounds.size.width - 50, y: 150)
                }
            }
            
            Text(news.title)
                .font(Font.headline.weight(.bold))
                .padding(5)
                .multilineTextAlignment(.leading)
            
        }.onAppear {
            isLiked = news.isLiked
        }
    }
    
    
}

