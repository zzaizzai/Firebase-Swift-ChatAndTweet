//
//  MyProfileView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI

class MyProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage = ""
    
    init() {
        
        fetchCurrentUser()
        
    }
    
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.errorMessage = "no user"
            return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("\(error)")
                self.errorMessage = "\(error)"
                return
            }
            
            self.currentUser = try? snapshot?.data(as: User.self)
            FirebaseManager.shared.currentUser = self.currentUser
            
        }
    }
}

struct MyProfileView: View {
    @ObservedObject private var vm = MyProfileViewModel()
    
    
    var body: some View {
        ScrollView{
            VStack {
                LazyVStack(alignment: .leading) {
                    Text(vm.errorMessage)
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
                            Text(vm.currentUser?.uid ?? "uid")
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
