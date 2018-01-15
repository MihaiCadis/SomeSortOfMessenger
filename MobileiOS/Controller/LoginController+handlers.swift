//
//  LoginController+handlers.swift
//  MobileiOS
//
//  Created by Cadis Mihai on 12/01/2018.
//  Copyright © 2018 Cadis Mihai. All rights reserved.
//

import UIKit
import Firebase

extension LogInViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController() 
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
            
        } else if  let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @objc func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text
            else
        {
            return // Make Pop-Up Alert
            
        }
        
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            
            if error != nil{
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("usersProfileImage").child("\(imageName).png") 
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, errror) in
                    if errror != nil {
                        print(errror!)
                    }
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString{
                                                let values = ["name": name,"email": email, "profileImageURL": profileImageURL]
                        self.registerUserInDatabaseWithUId(uid: uid, values:values as [String : AnyObject])
                    }
                    
                })
            }
            // succesfully registered the user
            
            
        }
        
    }
    
    private func registerUserInDatabaseWithUId(uid: String, values: [String:AnyObject]){
        let ref = Database.database().reference(fromURL: "https://mobileios-47fb4.firebaseio.com/")
        let userReference = ref.child("users").child(uid)
        
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            print("User saved successfully into Firebase Database")
        })
    }
    
    
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        logInRegisterButton.setTitle(title, for: .normal)
        
        
        // Change height of inputContainerView
        inputContainterViewHeightConstraint?.constant =
            loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        
        // Change height of nameTextField
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor? = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor? = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor? = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        profileImageViewHeightAnchor?.isActive = false
        profileImageViewHeightAnchor? = profileImageView.heightAnchor.constraint(equalToConstant: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 100)
        profileImageViewHeightAnchor?.isActive = true
        
        
    }
    @objc func handleLoginRegister(){
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }}
    
    @objc func handleLogin(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text
            else{
                // Make Pop-up alert
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error!)
                return
            }
        }
        
        // successfully logged in
        self.dismiss(animated: true, completion: nil)
        
    }
}
