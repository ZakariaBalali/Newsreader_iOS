//
//  ContentView.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel.loginVM
    @StateObject var newsViewModel = NewsViewModel()
    
    
    var body: some View {
        
        if loginViewModel.isAuthenticated {
            TabView {
                NavigationView {
                    NewsListView(newsViewModel: newsViewModel)
                    .navigationBarItems(leading: Button(action: {
                        self.doOnceLoggedout()
                    }, label: {VStack{Text("Log out")}}))
                    .navigationTitle("Home")
                }.navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                NavigationView {
                    FavoriteListView(newsViewModel: newsViewModel)
                        .navigationBarItems(leading: Button(action:  {
                            self.doOnceLoggedout()
                        }, label: {VStack{ Text("Log out")}}))
                        .navigationTitle("Favorites")
                }.navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorites")
                    }
            }
        } else if !loginViewModel.isAuthenticated{
            TabView {
                NavigationView {
                    NewsListView(newsViewModel: newsViewModel)
                    .navigationBarItems(trailing: NavigationLink(destination: LoginView(newsViewModel: newsViewModel), label: {VStack{Text("Log in")}}))
                    .navigationTitle("Home")
                }.navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                NavigationView {
                    FavoriteListView(newsViewModel: newsViewModel)
                        .navigationBarItems(trailing: NavigationLink(destination: LoginView(newsViewModel: newsViewModel), label: {VStack{Text("Log in")}}))
                        .navigationTitle("Favorite")
                }.navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("Favorite")
                    }
            }
        }
        
    }
    
    func doOnceLoggedout() {
        self.loginViewModel.logout()
        self.newsViewModel.likedNewsArticles.removeAll()
        self.newsViewModel.nextIdForLikedArticles = -1
        self.newsViewModel.newsArticles.removeAll()
        self.newsViewModel.fetchNewsArticles {_ in}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

