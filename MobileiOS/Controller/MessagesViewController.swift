//
//  ViewController.swift
//  MobileiOS
//
//  Created by Cadis Mihai on 18/12/2017.
//  Copyright © 2017 Cadis Mihai. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleNewMessage))
    
        
        
        
    }
    
    @objc func handleNewMessage(){
        
        let newMessageController = NewMessageTableViewController()
        let newMessageNavigationController = UINavigationController(rootViewController: newMessageController)
        present(newMessageNavigationController, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogOut), with: nil, afterDelay: 0)
        }
        else {
            let uid = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.navigationItem.title = dictionary["name"] as? String
                    }
                    
                }, withCancel: nil)
            }
        
        
    }
    
    @objc func handleLogOut(){
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LogInViewController()
        present(loginController, animated: true, completion: nil)
        
    }
}

