//
//  RecentMessagesView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/22.
//

import SwiftUI

struct RecentMessagesView: View {
    var body: some View {
        ScrollView {
            ForEach(0 ..< 5) { recentMeesage in
                Button {
                    print("recentMessage")
                } label: {
                    HStack{
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFill()
                            .background(Color.black)
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(100)
                        VStack{
                            HStack{
                                Text("name")
                                Spacer()
                                Text("Date")
                                    .foregroundColor(Color.gray)
                            }
                            Text("text of the recent message that you friend are talking with you")
                        }
                    }
                   
                }
                .foregroundColor(Color.black)
                .padding()
                
                Divider()
                
                
            }
            
        }
    }
}

struct RecentMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        RecentMessagesView()
    }
}
