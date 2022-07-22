//
//  MyProfileView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI

class MyProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    
    init() {
        
    }
    
    
//    func fetchCurrentUser() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
//        FirebaseManager.shared.firestore.collection("users")
//    }
}

struct MyProfileView: View {
    
    
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
                            Text("name")
                                .font(.system(size: 25))
                            Text("email")
                                .foregroundColor(Color.gray)
                            Text("content")
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
