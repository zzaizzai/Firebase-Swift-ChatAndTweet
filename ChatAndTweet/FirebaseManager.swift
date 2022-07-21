//
//  FirebaseManager.swift
//  ChatAndTweet
//
//  Created by 小暮準才 on 2022/07/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore

    var currentUser: User?
    
    static let shared = FirebaseManager()
    
    override init() {
        
        FirebaseApp.configure()
        print("connected Firebase")
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
