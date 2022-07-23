//
//  MyProfileView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI

struct MyProfile {
    let uid, name, email, profileImageurl: String
    let joinDate : Date
}

class MyProfileViewModel: ObservableObject {
    @Published var currentUser: MyProfile?
    @Published var errorMessage = ""
    
    init() {
        
        fetchCurrentUser()
        
    }
    
    
    func fetchCurrentUser() {
        
        self.errorMessage = "fetching current user"
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "no user1"
            return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("\(error)")
                self.errorMessage = "\(error)"
                return
            }
            
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "no data"
                return
            }
            
            
            let email = data["email"] as? String ?? "no email"
            let name = data["name"] as? String ?? "no name"
            let profileImageUrl = data["profileImageUrl"] as? String ?? "no image"
            let joinDate = data["joinDate"] as? Date ?? Date()
            
            self.currentUser = MyProfile(uid: uid, name: name, email: email, profileImageurl: profileImageUrl, joinDate: joinDate)
            self.errorMessage = "fetch done"
            FirebaseManager.shared.currentUser = User(uid: uid, name: name, email: email, profileImageurl: profileImageUrl, joinDate: joinDate)
            

            
        }
    }
}

struct MyProfileView: View {
    @ObservedObject private var vm = MyProfileViewModel()
    
    
    var body: some View {
        ScrollView{
            VStack {
                LazyVStack(alignment: .leading) {

                    HStack{
                        Image(systemName: "photo")
                            .frame(width: 60, height: 60)
                            .background(Color.black)
                            .cornerRadius(100)
                        
                        VStack(alignment: .leading){
                            Text(vm.currentUser?.name ?? "my name")
                                .font(.system(size: 25))
                            Text(vm.currentUser?.email ?? "my email")
                                .foregroundColor(Color.gray)
                            Text("uid: \(vm.currentUser?.uid ?? "no uid")")
                            Text(vm.currentUser?.joinDate.description ?? "home")
                        }
                        .padding(.leading, 10)
                    }
                    
                    HStack{
                        Text("100 following")
                            .fontWeight(.bold)
                        Text("100 follower")
                            .fontWeight(.bold)
                    }
                }
            }
            Divider()
            
            VStack{
                Text(vm.errorMessage)
                ForEach(0 ..< 5) { post in
                    Text("post")
                    
                }
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
