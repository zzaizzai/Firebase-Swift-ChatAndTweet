//
//  Post.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/21.
//

import Foundation
import FirebaseFirestoreSwift

//struct Post: Identifiable, Codable {
//
//    @DocumentID var id : String?
//
//    let authorUid, content : String
//    let authorName, authorEmail : String
//    let date: Date
//    var likes: Int
//
//}
//

//struct MyLikedPost: Identifiable {
//
//    var id: String {documentId}
//    let documentId: String
//
//    let authorUid, content : String
//    let authorName, authorEmail : String
//    let authorProfileUrl : String
//    let date: Date
//    var likes: Int
//    var liked: Bool
//
//    init(documentId: String, data: [String:Any]) {
//        self.documentId = documentId
//
//        self.content = data["content"] as? String ?? "no content"
//        self.authorUid = data["authorId"] as? String ?? "no authorId"
//        self.authorName = data["authorName"] as? String ?? "no authorName"
//        self.authorEmail = data["authorEmail"] as? String ?? "no authorEmail"
//        self.authorProfileUrl = data["authorProfileUrl"] as? String ?? "no authorProfileUrl"
//        self.date = data["date"] as? Date ?? Date()
//        self.likes = data["likes"] as? Int ?? 0
//        self.liked = data["liked"] as? Bool ?? false
//    }
//}
