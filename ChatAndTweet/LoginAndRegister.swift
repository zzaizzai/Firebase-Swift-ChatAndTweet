//
//  LoginAndRegister.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/20.
//

import SwiftUI
import Firebase


struct RegisterView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var passwordCheck = ""
    @State var errorMessage = ""
    @State var successMessage = ""
    
    @Environment(\.presentationMode) var presentation
    
    
    var body: some View {

            
        
        NavigationView {
            ScrollView {
                VStack {
                    Group{
                        TextField("name", text: $name)
                        
                        TextField("email", text: $email)
                        
                        TextField("password", text: $password)
                        
                        TextField("passwordCheck", text: $passwordCheck)
                    }
                    .padding()
                    .background(Capsule().fill(Color.white))
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    
                    
                    Button {
                        self.presentation.wrappedValue.dismiss()
                    } label: {
                        Text("Do you have account?")
                    }
                    
                    ZStack {
                        Text(self.errorMessage)
                            .foregroundColor(Color.red)
                        .padding()
                        
                        Text(self.successMessage)
                            .foregroundColor(Color.blue)
                            .padding()
                    }
                    
                    Button {
                        print("photo")
                    } label: {
                        Image(systemName: "photo")
                            .font(.system(size: 45))
                            .foregroundColor(Color.black)
                    }

                    
                    Button {
                        register(name: self.name, email: self.email, password: self.password, passwordCheck: self.passwordCheck)
                    } label: {
                        Spacer()
                        Text("Sign Up")
                            .padding()
                        Spacer()
                    }
                    .background(Capsule().fill(Color.white))
                    .padding()

                    
                    
                    
                    Spacer()
                }
            }
            .navigationTitle("Register")
            .background(Color(.init(white: 0, alpha: 0.14)))
        }
        
    }
    
    func register(name: String, email: String, password: String, passwordCheck: String) {
        if name.count < 4 || email.count < 4 || password.count < 4 {
            self.errorMessage = "enter at least 4 characters"
            self.successMessage = ""
            return
        }
        
        if password != passwordCheck {
            self.errorMessage = "incorrect password check"
            self.successMessage = ""
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password) { result, error in
            if let error = error {
                self.errorMessage = "\(error)"
                return
            }
            self.successMessage = "signed up"
            self.errorMessage = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.presentation.wrappedValue.dismiss()
            }
        }


            
        
    }
    
}

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @State var successMessage = ""
    
    
    var body: some View {
        

            NavigationView {
                ScrollView {
                    VStack {
                        
                        Group{
                            
                            
                            TextField("email", text: $email)
                            
                            TextField("password", text: $password)
                            
                            
                        }
                        .padding()
                        .background(Capsule().fill(Color.white))
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        
                        NavigationLink {
                            RegisterView()
                                .navigationBarHidden(true)
                        } label: {
                            Text("Do you wanna join us??")
                        }
                        
                        ZStack {
                            Text(self.errorMessage)
                                .foregroundColor(Color.red)
                            .padding()
                            
                            Text(self.successMessage)
                                .foregroundColor(Color.blue)
                                .padding()
                        }
                        

                        
                        Button {
                            login(email: self.email, password: self.password)
                        } label: {
                            Spacer()
                            Text("Login")
                                .padding()
                            Spacer()
                        }
                        .background(Capsule().fill(Color.white))
                        .padding()
                        
                    }
                }
                .navigationTitle("Login")
                .background(Color(.init(white: 0, alpha: 0.14)))
            }
    }
    
    func login(email: String, password: String) {
        print("email: \(email), password: \(password)")
        if email.count < 4 || password.count < 4 {
            self.errorMessage = "enter at least 4 characters"
            self.successMessage = ""
            return
        }
        FirebaseManager.shared.auth.signIn(withEmail: self.email, password: self.password) {
            resulr, error in
            if let error = error {
                self.successMessage = ""
                self.errorMessage = "\(error)"
                return
            }
            
            self.successMessage = "logged in"
            self.errorMessage = ""
        }

    }
}






struct LoginAndRegister_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
