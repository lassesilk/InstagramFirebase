//
//  FirebaseUtils.swift
//  InstagramFirebase
//
//  Created by Lasse Silkoset on 02.08.2018.
//  Copyright © 2018 Lasse Silkoset. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String : Any] else { return }
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
        }) { (err) in
            print("failed to fetch user for posts", err)
        }
        
    }
}
