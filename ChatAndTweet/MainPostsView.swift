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

struct MainPostsView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView{
                LazyVStack {
                    Button {
                        print("refresh")
                    } label: {
                        Text("refresh")
                    }

                    ForEach(0 ..< 30) {post in
                            PostView()
                            .padding(.horizontal)
                            .padding(.bottom, 2)
                        
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
