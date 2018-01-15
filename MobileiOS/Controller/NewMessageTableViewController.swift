//
//  NewMessageTableViewController.swift
//  MobileiOS
//
//  Created by Cadis Mihai on 10/01/2018.
//  Copyright © 2018 Cadis Mihai. All rights reserved.
//

import UIKit
import Firebase


class NewMessageTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId )
        fetchUsers()
    }
    
    func fetchUsers(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            
            
            if let dictionary = snapshot.value as? [String:AnyObject]{
                
//                print("User found")
//                print(snapshot)
                
                let user = User()
                //user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImage = dictionary["profileImageURL"] as? String
                
                
                self.users.append(user)
                
                DispatchQueue.main.async(execute: { self.tableView.reloadData()})
                
                
            }
            
            
            
            
            
        }, withCancel: nil)
    }
    
    
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath )
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
//        cell.imageView?.image = UIImage(named: "emptyProfile")
//        cell.imageView?.contentMode = .scaleToFill
//        print(user.profileImage!)
        if let profileImageURL = user.profileImage {
            
            let url = URL(string: profileImageURL)
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                print(data!)
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                  })
            }).resume()
        }
        
        return cell
    }
    
}

class UserCell: UITableViewCell {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyProfile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        // iOS 9 constraints
        // need x,y,widht and height anchors
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






