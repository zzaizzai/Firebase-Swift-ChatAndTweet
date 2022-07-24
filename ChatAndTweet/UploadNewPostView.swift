//
//  UploadNewPost.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

class UploadnewPostViewModel: ObservableObject {
    @Published var didUploadPost = false
    @Published var errorMessage = "error"
    @Published var profileImageUrl = "none"
    
    init() {
        
        self.fetchCurrentUser()
        
        
    }
    
    func fetchCurrentUser() {
        guard let profileImageUrl = FirebaseManager.shared.currentUser?.profileImageurl else { return
        }
        self.profileImageUrl = profileImageUrl
    }
    
    
    func uploadNewPost(text: String, completion: @escaping(Bool) -> Void) {
        
        if text.count > 150 {
            self.errorMessage = "less than 100 characters"
            return
        }
        
        if text.count < 5 {
            self.errorMessage = "more than 5 characters"
            return
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "no user"
            return }
        
        guard let email = FirebaseManager.shared.currentUser?.email else {
            self.errorMessage = "no email"
            return }
        
        guard let name = FirebaseManager.shared.currentUser?.name else {
            self.errorMessage = "no name"
            return }
        
        guard let profileUrl = FirebaseManager.shared.currentUser?.profileImageurl else {
            return
        }
        
        
        let data =
        ["authorUid" : uid,
         "authorName": email,
         "authorEmail" : name,
         "authorProfileUrl": profileUrl,
         "content": text,
         "likes": 0,
         "date" : Date(),
        ] as [String : Any]
        
        FirebaseManager.shared.firestore.collection("posts").document().setData(data) { error in
            if let error = error {
                print("\(error)")
                self.errorMessage = "\(error)"
                completion(false)
                return
            }
            
            
            self.errorMessage = "done"
            completion(true)
            
        }
    }
}

struct UploadNewPostView: View {
    
    @ObservedObject var vm = UploadnewPostViewModel()
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var newPostText = ""
    
    
    var body: some View {
        VStack{
            
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancle")
                        .font(.title)
                        .padding(.horizontal)
                }

                
                Spacer()
                
                if self.newPostText.count < 150 {
                    Text(self.newPostText.count.description)
                } else {
                    Text(self.newPostText.count.description)
                        .foregroundColor(Color.red)
                }
                
                Button {
                    vm.uploadNewPost(text: self.newPostText) { _ in
                        presentationMode.wrappedValue.dismiss()
                        self.newPostText = ""
                    }
                    
                } label: {
                    Text("Upload")
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(50)
                        .padding()
                    
                }
            }
            
            Divider()
            
            HStack(alignment: .top){
                WebImage(url: URL(string: vm.profileImageUrl))
                    .resizable()
                    .frame(width: 55, height: 55)
                    .scaledToFill()
                    .background(Color.black)
                    .cornerRadius(100)
                    .padding(.horizontal, 10)
                
                
                ZStack(alignment: .leading){
                    TextEditor(text: self.$newPostText)
                        .font(.system(size: 25))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 18)
//                        .background(Color.gray)
                    
                    if self.newPostText.isEmpty {
                        VStack{
                            Text("What are you thinking about??")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 25))
                                .padding(.vertical, 25)
                                .padding(.horizontal, 10)
                                .zIndex(1)
                            Spacer()
                        }
                    }
                    
                }
                
            }
            
            
            
            Spacer()
            
            VStack{
                Text(vm.errorMessage)
                    .padding()
                
                
            }
            
        }
    }
}

struct UploadNewPost_Previews: PreviewProvider {
    static var previews: some View {
        UploadNewPostView()
    }
}
