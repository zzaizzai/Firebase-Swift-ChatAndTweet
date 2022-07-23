//
//  MainPostsView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

    
class MainPostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    @Published var firestoreListener : ListenerRegistration?
    @Published var errorMessage = "error"
    init() {
        fetchPosts()
        
    }
    
    func fetchPosts() {
        
        firestoreListener?.remove()
        self.posts.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore.collection("posts").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("\(error)")
                return
            }

            querySnapshot?.documentChanges.forEach({ change in
                let docId = change.document.documentID
                if let index = self.posts.firstIndex(where: { rm in
                    return rm.id == docId
                }) {
                    self.posts.remove(at: index)
                    self.errorMessage = "fetch done2"
                }
                
                do {
                    let rm = try change.document.data(as: Post.self)
                    self.posts.insert(rm, at: 0)
                    self.errorMessage = "fetch done3"
                } catch {
                    print(error)
                    self.errorMessage = "\(error)"
                }
            })
            
        }
        
    }

    
}

struct MainPostsView: View {
    @ObservedObject var vm = MainPostViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack {
                    VStack {
                        Button {
                            vm.fetchPosts()
                        } label: {
                            Text("refresh")
                        }
                        Text(vm.errorMessage)
                        
                        Button {
                            print("")
                        } label: {
                            Text("new post")
                        }
                        
                        
                        postsView
                        
                        
                    }
                }
                
                
            }
            
        }
        
    }
    
    private var postsView: some View {
        
        ForEach(vm.posts) { post in
            PostView(post: post )
            
        }
        
    }
    
    struct PostView: View {
        
        var post: Post
        
        var body: some View{
            
            LazyVStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFill()
                        .background(Color.black)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                    VStack(alignment: .leading){
                        HStack{
                            Text(post.authorName)
                                .font(.system(size: 25))
                            
                            Spacer()
                            
                            Text("date")
                                .foregroundColor(Color.gray)
                        }
                        Text("content content content content content content content content content content content content ")
                            .font(.system(size: 20))
                        
                        HStack{
                            
                            Button {
                                print("i like you")
                            } label: {
                                Image(systemName: "arrow.counterclockwise")
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                            
                            Button {
                                print("i want to talk with you")
                            } label: {
                                Image(systemName: "message")
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                            Button {
                                print("i like you")
                            } label: {
                                Image(systemName: "heart")
                                    .foregroundColor(Color.black)
                            }
                            Spacer()
                        }
                        .padding(.top, 4)
                    }
                }
            }
            
            
        }
        
    }
}




struct MainPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MainPostsView()
//        PostView()
    }
}
