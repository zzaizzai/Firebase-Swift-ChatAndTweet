//
//  Post.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id : String?
    
    let uid, title, content : String
    let date: Date
    var likes: Int
    
    var user: User?
    var didLike: Bool? = false
}
