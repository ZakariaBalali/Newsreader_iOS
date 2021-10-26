//
//  LoginView.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var newsViewModel: NewsViewModel
    @State var username: String = ""
    @State var password: String = ""
    @State var isTryingToLogin: Bool = false
    @State var isRequestErrorViewPresented: Bool = false
        
    var body: some View {
        VStack {
            if isTryingToLogin {
                ProgressView("Logging in...")
            } else {
                
                TextField("Enter Username", text: $username)
                    .autocapitalization(.none)
                    .padding(10)
                    .border(Color.black, width: 0.5)
                SecureField("Enter Password", text: $password)
                    .padding(10)
                    .border(Color.black, width: 0.5)
                Button(action: {
                    isTryingToLogin = true
                    LoginViewModel.loginVM.login(for: Login(username: username, password: password)) { result in
                        switch result {
                        case .success(_):
                            self.newsViewModel.fetchNewsArticles {_ in}
                        case.failure(let error):
                            self.isRequestErrorViewPresented = true
                            switch error {
                            case .urlError(let urlError):
                                print("URL Error: \(String(describing: urlError))")
                            case .decodingError(let decodingError):
                                print("Decoding Error: \(String(describing: decodingError))")
                            case .genericError(let error):
                                print("Error: \(String(describing: error))")
                            }
                        }
                        self.isTryingToLogin = false
                    }
                }, label: {
                    Text("Log in")
                        .frame(maxWidth: .infinity, minHeight:50)
                        .foregroundColor(.white)
                })
                    .background(Color.init(.blue))
                    
            }
            
            VStack {
                NavigationLink(destination: RegisterView(), label: { Text("Click here to sign up") })
            }
            .padding(5)
            
        }.padding()
            .alert(isPresented: $isRequestErrorViewPresented) {
                Alert(title: Text("Error"), message: Text("Could not login"), dismissButton: .default(Text("Ok")))
            }
            .navigationTitle("Login")
    }
    
    
    
}

