//
//  MainPostsView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/21.
//

import SwiftUI

struct PostView: View {
    var body: some View {
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
                        Text("name")
                            .font(.system(size: 25))
                        
                        Spacer()
                        
                        Text("date")
                            .foregroundColor(Color.gray)
                    }
                    Text("content")
                        .font(.system(size: 15))
                    
                    HStack{
                        Image(systemName: "arrow.counterclockwise")
                        Spacer()
                        Image(systemName: "paperplane")
                        Spacer()
                        Image(systemName: "heart")
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct MainPostsView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView{
                LazyVStack {
                    ForEach(0 ..< 30) {post in
                            PostView()
                            .padding()
                        Divider()
                    }
                }
            }
        }
    }
}

struct MainPostsView_Previews: PreviewProvider {
    static var previews: some View {
        MainPostsView()
    }
}
