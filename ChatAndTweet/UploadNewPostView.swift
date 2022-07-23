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
    @State private var newPostText = "new post"
    
    
    var body: some View {
        VStack{
            
            HStack{
                
                WebImage(url: URL(string: vm.profileImageUrl))
                    .resizable()
                    .frame(width: 55, height: 55)
                    .scaledToFill()
                    .background(Color.black)
                    .cornerRadius(100)
                    .padding()
                
                Spacer()
                
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
            
            TextField("what are you thinking", text: $newPostText)
                .autocapitalization(.none)
                .padding()
            
            Spacer()
            
            VStack{
                Text(vm.errorMessage)
                

            }
            
        }
    }
}

struct UploadNewPost_Previews: PreviewProvider {
    static var previews: some View {
        UploadNewPostView()
    }
}
