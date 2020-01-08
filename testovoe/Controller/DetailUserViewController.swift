//
//  DetailUserViewController.swift
//  testovoe
//
//  Created by Anastasia on 09.01.2020.
//  Copyright © 2020 Anastasia. All rights reserved.
//

import UIKit
import Firebase

class DetailUserViewController: UIViewController {
    
    
    var profileView: ProfileView!
    
    var nickname: String?
    var firstName: String?
    var lastName: String?
    var date: String?
    var image: UIImage?
    
    
    
    var ref: DatabaseReference!
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        profileView = ProfileView(frame: view.bounds)
        
        self.view.addSubview(profileView)
        
        view.backgroundColor = .white
        
        title = nickname
        
        
        
        showProfile()
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Show profile
    func showProfile() {
        
        profileView.loginTextField.text = nickname
        profileView.firstNameTextField.text = firstName
        profileView.lastNameTextField.text = lastName
        profileView.dateOfBirthTextField.text = date
        profileView.photoImage.image = image
        
        
        
        
}

}
