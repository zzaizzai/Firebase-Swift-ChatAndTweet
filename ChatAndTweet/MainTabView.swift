//
//  MainTapView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI


struct MainTabView: View {
    

    
//    @State private var selectedIndex: Int = 0
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
                //                    .navigationBarTitle(Text("message"), displayMode: .inline)
                    .tag("message")
                
                Text("My Page")
                    .tabItem {
                        Image(systemName: "person")
                    }
                //                    .navigationBarTitle(Text("my profile"), displayMode: .inline)
                    .tag("profile")
                
                Text("Setting Page")
                    .tabItem {
                        Image(systemName: "gearshape")
                    }
                    .tag("setting")
            }
            .navigationBarTitle(selectedTab.description)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainTapView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
