//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Lasse Silkoset on 07.08.2018.
//  Copyright © 2018 Lasse Silkoset. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String : Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
