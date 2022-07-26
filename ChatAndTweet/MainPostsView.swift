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
import SDWebImageSwiftUI


struct Post: Identifiable, Codable {
    
    @DocumentID var id : String?
    
    let authorUid, content : String
    let authorName, authorEmail, authorProfileUrl : String
    let date: Date
    var likes: Int
    
    var didLike: Bool? = false
    
}


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
        
        firestoreListener = FirebaseManager.shared.firestore.collection("posts").order(by: "date").addSnapshotListener { querySnapshot, error in
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
    @State var isUploadMode = false
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack {
                    VStack {
                        HStack{
                            Button {
                                vm.fetchPosts()
                            } label: {
                                Text("refresh")
                            }
                            
                            Spacer()
                            
                            Text(vm.errorMessage)
                            
                            Spacer()
                            
                            Button {
                                self.isUploadMode.toggle()
                            } label: {
                                Text("+")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 25))
                                    .frame(width: 20, height: 20)
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(1100)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.horizontal)
                        
                        
                        postsView
                        
                        
                    }
                }
                
                
            }
            
        }
        .fullScreenCover(isPresented: $isUploadMode) {
            UploadNewPostView()
        }
        
    }
    
    private var postsView: some View {
        VStack{
            
            Divider()
            ForEach(vm.posts) { post in
                PostView(noCheckPost: post)
                Divider()
                
            }
            
        }
        
    }
    
}

class PostViewModel: ObservableObject {
    @Published var mainPost : Post
    
    init(noCheckPost: Post) {
        self.mainPost = noCheckPost
        checkLikedOfPost()
    }
    
    
    func checkLikedOfPost() {
        checkILikedItOrNot(postNoCheckLiked: mainPost) { didLike in
            if didLike {
                self.mainPost.didLike = true
            }
        }
    }
    
    func checkILikedItOrNot( postNoCheckLiked: Post, completion: @escaping(Bool)-> Void) {
        
        guard let postId = postNoCheckLiked.id else { return }
        guard let myUid = FirebaseManager.shared.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("likes").document(myUid).collection("likePosts").document(postId).getDocument { snapshot, error in
            if let error = error {
                print("\(error)")
                return }
            guard let snapshot = snapshot else { return }
            completion(snapshot.exists)
            
            
        }
    }
    
    func unLikeButton() {
        
        guard let myUid = FirebaseManager.shared.currentUser?.uid else { return }
        guard let postUid = self.mainPost.id else { return }
        
        FirebaseManager.shared.firestore.collection("likes").document(myUid).collection("likePosts").document(postUid).delete { error in
            if let error = error {
                print("\(error)")
                return
            }
        }
        
        self.mainPost.didLike = false
        
    }
    
    func likeButton() {
        
        guard let myUid = FirebaseManager.shared.currentUser?.uid else { return }
        guard let postUid = self.mainPost.id else { return }
        
        let data = [
            "postUid" : postUid,
            "date" : Date(),
            "postDate": mainPost.date
            
        ] as [String : Any]
        
        FirebaseManager.shared.firestore.collection("likes").document(myUid).collection("likePosts").document(postUid).setData(data) { error in
            if let error = error {
                print(error)
                return
            }
            
            print("like done")
            self.mainPost.didLike = true
        }
        
    }
    
}


struct PostView: View {
    
    @ObservedObject var vm : PostViewModel
    
    
    init(noCheckPost: Post){
        self.vm = PostViewModel(noCheckPost: noCheckPost)
    }
    
    
    var body: some View{
        
        LazyVStack(alignment: .leading) {
            if let post = self.vm.mainPost {
                HStack(alignment: .top) {
                    
                    WebImage(url: URL(string: post.authorProfileUrl))
                        .resizable()
                        .scaledToFill()
                        .background(Color.black)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text(post.authorName)
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            VStack(alignment: .trailing){
                                Text(post.date, style: .date)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 12))
                                
                                Text(post.date, style: .time)
                                    .foregroundColor(Color.gray)
                                    .font(.system(size: 12))
                            }
                        }
                        Text(post.content)
                            .font(.system(size: 18))
                        
                        HStack{
                            
                            Button {
                                print("repost in my profile")
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
                            if post.didLike == true {
                                Button {
                                    vm.unLikeButton()
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(Color.red)
                                }
                            } else {
                                Button {
                                    vm.likeButton()
                                } label: {
                                    Image(systemName: "heart")
                                        .foregroundColor(Color.black)
                                }
                            }
                            Text(post.likes.description)
                            Spacer()
                            
                        }
                        .padding(.top, 4)
                        
                    }
                    
                    
                }.padding(.horizontal, 12)
            }
            
        }
        
    }
    
}




struct MainPostsView_Previews: PreviewProvider {
    static var previews: some View {
        //        MainPostsView()
        //                PostView()
        MainTabView()
    }
}
