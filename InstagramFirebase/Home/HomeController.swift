//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Lasse Silkoset on 01.08.2018.
//  Copyright © 2018 Lasse Silkoset. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    var cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        
        fetchPosts()
        fetchFollowingUserIds()
        
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String : Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
                
            })
 
        }) { (err) in
            print("failed to fetch user ids", err)
        }
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //            print(snapshot.value)
            
            guard let dictionaries = snapshot.value as? [String : Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                //                print("key: \(key), value: \(value)")
                
                guard let dictionary = value as? [String: Any] else { return }
                
                let post = Post(user: user, dictionary: dictionary)
                
                
                self.posts.append(post)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("failed to fetch posts", err)
        }
    }
    
    func setupNavigationItems() {
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //Username, userProfileImageView
        height += view.frame.width
        height += 50
        height += 60
    
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
}
