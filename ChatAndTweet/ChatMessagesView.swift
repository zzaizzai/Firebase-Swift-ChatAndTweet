//
//  ChatMessagesView.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/31.
//

import SwiftUI


struct ChatMessage: Identifiable {
    
    var id: String { documentId }
    
    let documentId: String
    let fromId, toId, content: String
    
    init(documentId: String, data: [String:Any]) {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? "no from id"
        self.toId = data["toId"] as? String ?? "no to id"
        self.content = data["text"] as? String ?? "no content"
    }
    
    
}

struct ChatMessagesView: View {
    
    @State var chatText = "text"
    
    var body: some View {
        ZStack{
            messagesView

        }
        .navigationTitle("email")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        ScrollView {
            VStack{
                MessageView(documentId: "123", fromId: "1234", toId: "12345", content: "hello bro and sisters", date: Date())
                
                MessageView(documentId: "123", fromId: "1234", toId: "12345", content: "hello bro and sisters and mothers and fathers we know thath it is very important to be someones mother and father", date: Date())
                
                
                
            }
            .safeAreaInset(edge: .bottom) {
                chatBottom
            }
            
            
        }
    }
    
    
    private var chatBottom: some View {
        HStack{
            Image(systemName: "photo")
            TextField("hello", text: $chatText)
                .autocapitalization(.none)
            Button {
                print(chatText)
                self.chatText = ""
            } label: {
                Text("send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.gray)
        }
        .padding()
    }
}

struct MessageView: View {
    
//    var chatMessage: ChatMessage
    let documentId : String
    let fromId : String
    let toId: String
    let content: String
    let date: Date
    
    
    var body: some View {
        
        // oponent
        HStack(alignment: .top){
           
            
            HStack{
                
                Text(content)
                    .foregroundColor(Color.white)
                
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(30)
            
            Text(date, style: .time)
                .foregroundColor(Color.gray)
                .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal)
        
        
        // mine
        HStack(alignment: .top){
            Spacer()
            
            Text(date, style: .time)
                .foregroundColor(Color.gray)
                .padding(.vertical)
            
            HStack{
                
                Text(content)
                    .foregroundColor(Color.white)
                
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(30)
        }
        .padding(.horizontal)
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView()
    }
}
