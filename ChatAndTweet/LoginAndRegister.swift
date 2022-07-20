//
//  LoginAndRegister.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/20.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var errorMessage = "errorMessage"
    
    init(){
        
    }
    
    
    func login(email: String, password: String) {
        print("email: \(email), password: \(password)")
        
    }
    
    func register(name: String, email: String, password: String, passwordCheck: String) {
        print(name, email, password, passwordCheck)
    }
}


struct RegisterView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var passwordCheck = ""
    @ObservedObject var vm = LoginViewModel()
    
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
                    
                    Text(vm.errorMessage)
                        .foregroundColor(Color.red)
                        .padding()
                    
                    Button {
                        print("")
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
    
}

struct LoginView: View {
    @State var isRegisterMode = false
    @State var email = ""
    @State var password = ""
    
    @ObservedObject var vm = LoginViewModel()
    
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
                        
                        Text(vm.errorMessage)
                            .foregroundColor(Color.red)
                            .padding()
                        
                        Button {
                            print("")
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
    

}






struct LoginAndRegister_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
