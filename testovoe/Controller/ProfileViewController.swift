//
//  ProfileViewController.swift
//  testovoe
//
//  Created by Anastasia on 21.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {
    
    let currentUser = UserDefaults.standard.string(forKey: "currentUser")
    
    let defaults = UserDefaults.standard
    
    var profileView: ProfileView!
    
    var textFieldIsEditing = false
    
    var picker: UIDatePicker!
    
    var dateBD = Date()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checkLogin()
        
        profileView = ProfileView(frame: view.bounds)
        self.view.addSubview(profileView)
        
        view.backgroundColor = .white
        
        
        
        //print(currentUser!)
        
        title = "Профиль"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(exit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
        
        showProfile()
        
        let tapGesturePhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto(_:)))
        profileView.photoImage.addGestureRecognizer(tapGesturePhoto)
        
        
        profileView.dateOfBirthTextField.addTarget(self, action: #selector(chooseDate), for: .editingDidBegin)
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -150
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
        
        let tapKey: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapKey)
        
        profileView.buttonGroup.addTarget(self, action: #selector(goToGroups), for: .touchUpInside)
        
        
        
    }
    
    @objc func goToGroups() {
        navigationController?.pushViewController(GroupViewController(), animated: true)
    }
    
    func checkLogin() {
        if currentUser == nil {
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: false)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK - Choose date
    @objc func chooseDate() {
        print("OK")
        
        dismissKeyboard()
        picker = UIDatePicker()
        picker.datePickerMode = .date
        
        
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.addSubview(picker)
        picker.addTarget(self, action: #selector(chooseDateOfBirth), for: .valueChanged)
        let save = UIAlertAction(title: "Сохранить", style: .default) { _ in
            let date = DateFormatter()
            date.dateFormat = "dd-MM-YYYY"
            self.profileView.dateOfBirthTextField.text = date.string(from: self.picker.date)
            print(self.profileView.dateOfBirthTextField.text!)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        actionSheet.addAction(save)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    //MARK: - Logout
    @objc func exit() {
        
        
        navigationController?.pushViewController(LoginViewController(), animated: false)
        defaults.set(nil, forKey: "currentUser")
        
    }
    
    //MARK - Allows editing
    @objc func editProfile() {
        textFieldIsEditing = true
        profileView.photoImage.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfile))
        
    }
    
    //MARK: - Choose photo from gallery
    @objc func pickPhoto(_ gesture: UITapGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.choosePhoto(source: .camera)
            }
            let photo = UIAlertAction(title: "Галерея", style: .default) { _ in
                self.choosePhoto(source: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        }
    }
    
    //MARK: - Choose date of birth
    @objc func chooseDateOfBirth(sender: UIDatePicker) {
        if sender.isEqual(self.picker) {
            print(sender.date)
            dateBD = sender.date
        }
    }
    //MARK: - Save changes
    @objc func saveProfile() {
        let user = StorageManager.getDataUsers(currentUser!)
        
        try! realm.write {
            user.login = profileView.loginTextField.text!
            user.firstName = profileView.firstNameTextField.text!
            user.lastName = profileView.lastNameTextField.text!
            user.dateOfBirth = dateBD
            user.photo = profileView.photoImage.image?.pngData()
        }
        
        defaults.set(user.login, forKey: "currentUser")
        
        textFieldIsEditing = false
        profileView.photoImage.isUserInteractionEnabled = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
        
        
    }
    
    //MARK: - Show profile
    func showProfile() {
        if currentUser != nil {
            let user = StorageManager.getDataUsers(currentUser!)
            
            //let user = StorageManager.getDataUsers(currentUser!)
            
            if user.photo == nil {
                profileView.photoImage.image = UIImage(named: "photo")
            } else {
                profileView.photoImage.image = UIImage(data: user.photo!)
            }
            
            profileView.loginTextField.text = user.login
            profileView.firstNameTextField.text = user.firstName
            profileView.lastNameTextField.text = user.lastName
            profileView.dateOfBirthTextField.text = String(describing: user.dateOfBirth)
            
            
            profileView.loginTextField.delegate = self
            profileView.firstNameTextField.delegate = self
            profileView.lastNameTextField.delegate = self
            
            if user.dateOfBirth != nil {
                let date = DateFormatter()
                date.dateFormat = "dd-MM-YYYY"
                profileView.dateOfBirthTextField.text = date.string(from: user.dateOfBirth!)
            } else {
                profileView.dateOfBirthTextField.text = "Не указано"
            }
        }
        else {
            exit()
        }
    }
    
    
    
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldIsEditing == true {
            return true
        } else {
            return false
        }
    }
    
}

//MARK: - Work with photo
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePhoto(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let photoPicker = UIImagePickerController()
            photoPicker.allowsEditing = true
            photoPicker.sourceType = source
            photoPicker.delegate = self
            present(photoPicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileView.photoImage.image = info[.editedImage] as? UIImage
        profileView.photoImage.contentMode = .scaleAspectFill
        profileView.photoImage.clipsToBounds = true
        dismiss(animated: true)
    }
}

