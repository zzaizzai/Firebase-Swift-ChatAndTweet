//
//  MyProfileView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase


struct MyProfile {
    let uid, name, email, profileImageurl: String
    let joinDate : Date
}

class MyProfileViewModel: ObservableObject {
    @Published var currentUser: MyProfile?
    @Published var errorMessage = ""
    @Published var isUserLoggedOut = false
    @Published var myPosts = [Post]()
    @Published var firestoreListener : ListenerRegistration?
    
    
    init() {
        
        DispatchQueue.main.async {
            self.isUserLoggedOut = FirebaseManager.shared.currentUser?.uid == nil
            
            if self.currentUser?.uid == nil {
                self.fetchCurrentUser()
               
            }
            self.fetchMyPosts()
        }
        

        
    }
    
    func fetchMyPosts() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        firestoreListener?.remove()
        self.myPosts.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore.collection("posts").whereField("authorUid", isEqualTo: uid).order(by: "date").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("\(error)")
                return
            }

            querySnapshot?.documentChanges.forEach({ change in
                let docId = change.document.documentID
                if let index = self.myPosts.firstIndex(where: { rm in
                    return rm.id == docId
                }) {
                    self.myPosts.remove(at: index)
                    self.errorMessage = "fetch done2"
                }
                
                do {
                    let rm = try change.document.data(as: Post.self)
                    self.myPosts.insert(rm, at: 0)
                    self.errorMessage = "fetch done3"
                } catch {
                    print(error)
                    self.errorMessage = "\(error)"
                }
                
            })
            
        }
    }
    
    func firebaseLogOut() {
        try? Firebase.Auth.auth().signOut()
        self.isUserLoggedOut = true
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
    @State var showOptions = false
    @State var currentFilter = "posts"
    @Namespace var animation
    
    
    var body: some View {
        ScrollView{
            VStack {
                LazyVStack(alignment: .leading) {

                    HStack{
                        WebImage(url: URL(string: vm.currentUser?.profileImageurl ?? "no url image"))
                            .resizable()
                            .frame(width: 65, height: 65)
                            .scaledToFill()
                            .background(Color.black)
                            .cornerRadius(100)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text(vm.currentUser?.name ?? "my name")
                                    .font(.system(size: 25))
                                
                                Spacer()
                                
                                
                                Button {
                                    self.showOptions.toggle()
                                } label: {
                                    Image(systemName: "gearshape")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 25))
                                }

                            }
                            Text(vm.currentUser?.email ?? "my email")
                                .foregroundColor(Color.gray)
//                            Text("uid: \(vm.currentUser?.uid ?? "no uid")")
//                            Text(vm.currentUser?.joinDate.description ?? "home")
//                            Text(FirebaseManager.shared.currentUser?.email ?? "Fireemail")
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        Spacer()
                        
                        Text("100 following")
                            .fontWeight(.bold)
                        
                        Text("100 follower")
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                }
            }
            Divider()
            
            
            
            VStack{
                
                filterBar
                
                Text(vm.errorMessage)
                
                
                
                if currentFilter == "posts" {
                    
                    ForEach(vm.myPosts) { post in
                        PostView(post: post)
                        
                    }
                    
                } else {
                    Text("liked posts")
                }

            }
            
            
        }
        .background(Color.white)
        
        .actionSheet(isPresented: $showOptions) {
            .init(title: Text("setting"),
                  buttons: [.destructive(Text("sign out"), action: {
                vm.firebaseLogOut()
            }), .cancel()
                           ]
        )}
        
        .fullScreenCover(isPresented: $vm.isUserLoggedOut) {
            LoginView {
                self.vm.isUserLoggedOut = false
                self.vm.fetchCurrentUser()
            }
        }
    }
    
    
    let filters = ["posts", "liked"]
    
    var filterBar: some View {
        HStack{
            
            ForEach(filters, id: \.self) { filter in
                VStack{
                    Text(filter)
                    
                    if currentFilter == filter {
                        Capsule()
                            .foregroundColor(Color.gray)
                            
                    } else {
                        Capsule()
                            .foregroundColor(Color.clear)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()){
                        self.currentFilter = filter
                        
                    }
                }
                
            }
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
//        MyProfileView()
        MyProfileView()
    }
}
