//
//  MainTapView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI

class MainTabViewModel: ObservableObject {
    @Published var isUserLoggedOut = false
    @Published var currentUser: User?
    

    init() {
        DispatchQueue.main.async {
            self.isUserLoggedOut = FirebaseManager.shared.currentUser?.uid == nil
        }
        
        
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("\(error)")
                return
            }
            
            self.currentUser = try? snapshot?.data(as: User.self)
            FirebaseManager.shared.currentUser = self.currentUser
        }
        
    }
}


struct MainTabView: View {
    

    @ObservedObject var vm = MainTabViewModel()
    @State private var selectedTab = "home"
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                MainPostsView()
                    .tabItem {
                        Image(systemName: "house")
                        
                    }
                    .tag("home")
                
                RecentMessagesView()
                    .tabItem {
                        Image(systemName: "message")
                    }
                    .tag("message")
                
                MyProfileView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .tag("profile")
                
                UploadNewPostView()
                    .tabItem {
                        Image(systemName: "pencil")
                    }
                    .tag("setting")
            }
            .navigationBarTitle(selectedTab.description)
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $vm.isUserLoggedOut) {
            LoginView {
                self.vm.isUserLoggedOut = false
                
            }
        }
    }
}

struct MainTapView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
