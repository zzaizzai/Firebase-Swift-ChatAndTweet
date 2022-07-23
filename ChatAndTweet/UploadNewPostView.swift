//
//  UploadNewPost.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/23.
//

import SwiftUI

class UploadnewPostViewModel: ObservableObject {
    @Published var didUploadPost = false
    @Published var errorMessage = "error"
    
    
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
        
        
        let data =
        ["authorUid" : uid,
         "authorName": email,
         "authorEmail" : name,
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


            TextField("hey", text: $newPostText)
                .autocapitalization(.none)
                .padding()
            Spacer()
            
            VStack{
                Text(vm.errorMessage)
                
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
            
        }
        .background(Color.gray)
    }
}

struct UploadNewPost_Previews: PreviewProvider {
    static var previews: some View {
        UploadNewPostView()
    }
}
