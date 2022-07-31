//
//  RecentMessagesView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecentMessagesView: View {
    var body: some View {
        ScrollView {
            VStack{
                RecentMessage(postUid: "uid", authorUid: "uid", authorName: "name", content: "messages that someone send you with something useless", authorProfileUrl: "https://firebasestorage.googleapis.com:443/v0/b/chatandtweet.appspot.com/o/88UUtRQkALPRAsTSdYRKtSYDq2V2?alt=media&token=7e3780e9-cce9-4577-a1ce-1155d9d9ec2a", date: Date())
                
                RecentMessage(postUid: "recentMeesage2", authorUid: "recentMeesage", authorName: "recentMeesage2", content: "I hope that you send me messages more frequently and plasure me becuze i am your gril friend but you dont i cant understand about that i think we should break up", authorProfileUrl: "https://firebasestorage.googleapis.com:443/v0/b/chatandtweet.appspot.com/o/G5rnokXaSJS0jFtWTv76FA71Kh02?alt=media&token=17c65e5a-c02e-4d4f-96d3-8e76c9542157", date: Date())
            }
            
        }
    }
}

struct RecentMessage: View {
    
    let postUid: String
    let authorUid: String
    let authorName: String
    let content: String
    let authorProfileUrl: String
    let date: Date
    
    var body: some View {
        
        Button {
            print("recentMessage")
        } label: {
            HStack{
                WebImage(url: URL(string: authorProfileUrl))
                    .resizable()
                    .scaledToFill()
                    .background(Color.black)
                    .frame(width: 50, height: 50)
                    .cornerRadius(100)
                
                
                VStack(alignment: .leading){
                    HStack{
                        Text(authorName)
                            .fontWeight(.bold)
                        Spacer()
                        Text(date, style: .time)
                            .foregroundColor(Color.gray)
                    }
                    VStack(alignment: .leading){
                        Text(content)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .foregroundColor(Color.gray)
                    }
                    
                }
            }
           
        }
        .foregroundColor(Color.black)
        .padding()
        
        Divider()
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        RecentMessagesView()
//        VStack{
//            RecentMessage(postUid: "uid", authorUid: "uid", authorName: "name", content: "messages that someone send you with something useless", authorProfileUrl: "gs://chatandtweet.appspot.com/88UUtRQkALPRAsTSdYRKtSYDq2V2", date: Date())
//
//            RecentMessage(postUid: "recentMeesage2", authorUid: "recentMeesage", authorName: "recentMeesage2", content: "I hope that you send me messages more frequently and plasure me becuze i am your gril friend but you dont i cant understand about that i think we should break up", authorProfileUrl: "gs://chatandtweet.appspot.com/88UUtRQkALPRAsTSdYRKtSYDq2V2", date: Date())
//        }
    }
}
