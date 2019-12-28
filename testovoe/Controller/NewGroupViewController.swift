//
//  NewGroupViewController.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
//import RealmSwift
import Firebase

class NewGroupViewController: UIViewController {
    
    var groupView: GroupView!
    var textFieldIsEditing = false
    var tableUpdated = false
    
    var user: Person!
    var ref: DatabaseReference!
    var groups = Array<Group>()
    
    //var groupVC = GroupViewController()
    
    var currentName: String?
    
    //var groups: Results<Group>!
    //var newGroup = Group()
    var photoIsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Person(user: currentUser)
        
        ref = Database.database().reference(withPath: "groups")
        
        
        if currentName != nil {
            title = "Группа \(currentName!)"
        } else {
            title = "Новая группа"
        }
        //groups = realm.objects(Group.self)
        
        groupView = GroupView(frame: view.bounds)
        self.view.addSubview(groupView)
        view.backgroundColor = .white
        
        let tapGesturePhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto(_:)))
        groupView.photoGroup.addGestureRecognizer(tapGesturePhoto)
        
        //showGroup()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(goBack))
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -150
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
        
        let tapKey: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapKey)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
        tableUpdated = true
    }
    
    @objc func editGroup() {
        textFieldIsEditing = true
        groupView.photoGroup.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGroup))
        
    }
    
    //MARK: - Save changes
    @objc func saveGroup() {
            
            var image: UIImage?
            if photoIsChanged {
                image = groupView.photoGroup.image
            } else {
                image = #imageLiteral(resourceName: "groupPhoto")
            }
            let imageData = image?.pngData()
            
        let group = Group(name: groupView.nameTextField.text!, descr: groupView.descriptionTextField.text!, users: ["\(self.user.uid)"])
        let groupRef = self.ref.child(group.name)
        groupRef.setValue(["name": group.name, "descr": group.descr, "users": group.users])
        
        
            
        textFieldIsEditing = false
        groupView.photoGroup.isUserInteractionEnabled = false
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup))
        
    }
    
//    func showGroup() {
//        
//        if currentName != nil {
//            let group = StorageManager.getDataGroups(currentName!)
//            
//            groupView.photoGroup.image = UIImage(data: group.image!)
//            groupView.nameTextField.text = group.name
//            groupView.descriptionTextField.text = group.descr
//        } else {
//            groupView.photoGroup.image = UIImage(named: "groupPhoto")
//            groupView.nameTextField.placeholder = "Название"
//            groupView.descriptionTextField.placeholder = "Описание"
//        }
//
//        groupView.nameTextField.delegate = self
//        groupView.descriptionTextField.delegate = self
//        
//    }
    
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
    
}

//MARK: - Work with photo
extension NewGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        groupView.photoGroup.image = info[.editedImage] as? UIImage
        groupView.photoGroup.contentMode = .scaleAspectFill
        groupView.photoGroup.clipsToBounds = true
        
        photoIsChanged = true
        dismiss(animated: true)
    }
}

extension NewGroupViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldIsEditing == true {
            return true
        } else {
            return false
        }
    }
    
}
