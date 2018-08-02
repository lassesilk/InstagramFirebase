//
//  User.swift
//  InstagramFirebase
//
//  Created by Lasse Silkoset on 02.08.2018.
//  Copyright © 2018 Lasse Silkoset. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
