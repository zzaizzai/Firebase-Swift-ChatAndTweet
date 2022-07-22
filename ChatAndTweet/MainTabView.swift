//
//  MainTapView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView() {
            MainPostsView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
                .navigationBarTitle("home")
                .navigationBarTitleDisplayMode(.inline)
            
            RecentMessagesView()
                .onTapGesture {
                    self.selectedIndex = 1
                }
                .tabItem {
                    Image(systemName: "message")
                }
                .tag(1)
                .navigationBarTitle("good")
                .navigationBarTitleDisplayMode(.inline)
            
            Text("My Page")
                .onTapGesture {
                    self.selectedIndex = 2
                }
                .tabItem {
                    Image(systemName: "person")
                }
                .tag(2)
                .navigationBarTitle("good")
                .navigationBarTitleDisplayMode(.inline)
            
            Text("Setting Page")
                .onTapGesture {
                    self.selectedIndex = 3
                }
                .tabItem {
                    Image(systemName: "gearshape")
                }
                .tag(3)
                .navigationBarTitle("good")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainTapView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
