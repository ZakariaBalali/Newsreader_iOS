//
//  RegisterView.swift
//  Newsreader636655
//
//  Created by user206680 on 10/24/21.
//

import Foundation

import SwiftUI

struct RegisterView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isTryingToSignup: Bool = false
    @State var requestErrorAlert: Bool = false
    @State var registrationSuccessAlert: Bool = false
    @State var message: LocalizedStringKey = ""
    @Environment(\.presentationMode) var presentationMode
    var isFormValid: Bool{
        username.count < 4 || password.count < 4 || confirmPassword.count < 4
    }
    
    var body: some View {
        VStack {
            if isTryingToSignup {
                ProgressView("Signing up...")
            } else {
                
                TextField("Enter username", text: $username)
                    .padding(10)
                    .border(Color.black, width: 0.5)
                SecureField("Enter Password", text: $password)
                    .padding(10)
                    .border(Color.black, width: 0.5)
                SecureField("Enter Password again", text: $confirmPassword)
                    .padding(10)
                    .border(Color.black, width: 0.5)
                Button(action: {
                    if password != confirmPassword {
                        message = "Password doesn't match"
                        requestErrorAlert = true
                    } else {
                        isTryingToSignup = true
                        LoginViewModel.loginVM.register(login: Login(username: username, password: password)) { result in
                            switch result {
                            case .success(let response):
                                if response.success {
                                    self.message = "Registration successful!"
                                    self.registrationSuccessAlert = true
                                }else {
                                    self.message = "Username already exists"
                                    self.requestErrorAlert = true
                                }
                            case.failure(let error):
                                self.requestErrorAlert = true
                                switch error {
                                case .urlError(let urlError):
                                    print("URL Error: \(String(describing: urlError))")
                                case .decodingError(let decodingError):
                                    print("Decoding Error: \(String(describing: decodingError))")
                                case .genericError(let error):
                                    print("Error: \(String(describing: error))")
                                }
                            }
                            self.isTryingToSignup = false
                        }
                    }
                    
                }, label: {
                    Text("Sign up")
                        .frame(maxWidth: .infinity, minHeight:44)
                        .foregroundColor(.white)
                })
                    .background(Color.init(.blue))
                    .disabled(isFormValid)
            }
            
        }.padding()
            .alert(isPresented: $requestErrorAlert) {
                Alert(title: Text("Error"), message: Text(message), dismissButton: .default(Text("Ok")))
            }
            .alert(isPresented: $registrationSuccessAlert) {
                Alert(title: Text("Registration"), message: Text(message), dismissButton: .default(Text("Login"), action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
            .navigationTitle("Sign up")
    }
}

