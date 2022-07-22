//
//  LoginAndRegister.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/20.
//

import SwiftUI
import Firebase


struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordCheck = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    
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
                        self.showImagePicker.toggle()
                    } label: {
                        ZStack{
                            if let profileImage = self.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .scaledToFill()
                                    .cornerRadius(100)
                            } else {
                                Image(systemName: "photo")
                                    .font(.system(size: 45))
                                    .foregroundColor(Color.black)
                            }
                        }
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
        .fullScreenCover(isPresented: $showImagePicker) {
            ImagePicker(image: $profileImage)
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
        
        if self.profileImage == nil {
            self.successMessage = ""
            self.errorMessage = "pick image"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password) { result, error in
            if let error = error {
                self.errorMessage = "\(error)"
                return
            }
            self.successMessage = "signed up"
            self.errorMessage = ""
            
            storeProfileImage()
            
        }
        
    }
    
    func storeProfileImage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.profileImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.errorMessage = "\(error)"
                self.successMessage = ""
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = "url: \(error)"
                    return
                }
                
                self.successMessage = "stored image with url: \(url?.absoluteString ?? "")"
                guard let url = url else { return }
                
                storeUserInformation(profileImageUrl: url)
            }
            
        }
    }
    
    private func storeUserInformation(profileImageUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let newUserData = [
            "name": self.name,
            "email": self.email,
            "uid": uid,
            "profileImageUrl": profileImageUrl.absoluteString,
            "joinDate": Date()
        ] as [String : Any]
        
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(newUserData) { error in
            if let error = error {
                self.errorMessage = "\(error)"
                return
            }
            
            self.successMessage = "stored user data"
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
