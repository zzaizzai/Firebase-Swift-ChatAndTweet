//
//  User.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    
    @DocumentID var id : String?
    let name, email, profileImageurl: String
}
