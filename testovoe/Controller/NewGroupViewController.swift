//
//  NewGroupViewController.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import Firebase

class NewGroupViewController: UIViewController {
    
    var groupView: GroupView!
    var textFieldIsEditing = false
    var tableUpdated = false
    var user: Person!
    var ref: DatabaseReference!
    var groups = Array<Group>()
    var currentId: String?
    var photoIsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Person(user: currentUser)
        ref = Database.database().reference().child("groups")
        currentTitle()
        groupView = GroupView(frame: view.bounds)
        self.view.addSubview(groupView)
        view.backgroundColor = .white
        showGroup()
        buttons()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(goBack))
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -150
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
    }
    
    func buttons() {
        groupView.memberButton.addTarget(self, action: #selector(goMembers), for: .touchUpInside)
        let tapGesturePhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto(_:)))
        groupView.photoGroup.addGestureRecognizer(tapGesturePhoto)
        
        
        
        if currentId != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup))
        } else {
            textFieldIsEditing = true
            groupView.photoGroup.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGroup))
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        groupView.nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        groupView.descriptionTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        let tapKey: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapKey)
    }
    
    func currentTitle() {
        if currentId != nil {
            ref.child(currentId!).observeSingleEvent(of: .value) { [weak self] snapshot in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String ?? ""
                self?.title = "Группа \"\(name)\""
            }
        } else {
            title = "Новая группа"
        }
    }
    
    @objc func textFieldChanged() {
        if groupView.nameTextField.text?.isEmpty == false && groupView.descriptionTextField.text?.isEmpty == false {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
        tableUpdated = true
    }
    
    @objc func goMembers() {
        let membersVC = GroupUsersViewController()
        membersVC.currentId = currentId!
        self.navigationController?.pushViewController(membersVC, animated: true)
    }
    
    
    
    @objc func editGroup() {
        textFieldIsEditing = true
        groupView.photoGroup.isUserInteractionEnabled = true
        groupView.nameTextField.borderStyle = .roundedRect
        groupView.descriptionTextField.borderStyle = .roundedRect
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGroup))
        
    }
    
    //MARK: - Save changes
    @objc func saveGroup() {
        
        let imageName = groupView.nameTextField.text
        let storageRef = Storage.storage().reference().child("\(imageName!).png")
        
        if let uploadData = self.groupView.photoGroup.image?.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storageRef.downloadURL { [weak self] (url, error) in
                    if let downloadUrl = url {
                        
                        
                        let directoryURL : NSURL = downloadUrl as NSURL
                        let urlString: String = directoryURL.absoluteString!
                        let group = Group(name: self!.groupView.nameTextField.text!, descr: self!.groupView.descriptionTextField.text!, users: "Admin")
                        if self!.currentId != nil {
                            self!.ref?.child(self!.currentId!).updateChildValues(["name": group.name, "descr": group.descr, "groupImage": urlString])
                            //self!.ref?.child(self!.currentId!).setValue(["name": group.name, "descr": group.descr, "users": group.users, "groupImage": urlString, "id": self!.currentId!])
                        } else {
                            let id = UUID().uuidString
                            let groupRef = self?.ref.child(id)
                            groupRef?.setValue(["name": group.name, "descr": group.descr, "users": group.users, "groupImage": urlString, "id": id])
                        }
                        
                    }
                }
            }
        }
        
        textFieldIsEditing = false
        groupView.photoGroup.isUserInteractionEnabled = false
        groupView.nameTextField.borderStyle = .none
        groupView.descriptionTextField.borderStyle = .none
        
        if currentId != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup))
        } else {
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func showGroup() {
        
        
        
        if currentId != nil {
            
            
            let showGroupRef = ref.child(currentId!)
            
            showGroupRef.observe(.value) { [weak self] (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    self?.groupView.nameTextField.text = dictionary["name"] as? String
                    self?.groupView.descriptionTextField.text = dictionary["descr"] as? String
                    guard let urlString = dictionary["groupImage"] as? String else {
                        self?.groupView.photoGroup.image = UIImage(named: "groupPhoto")
                        return
                    }
                    let url = URL(string: urlString)
                    DispatchQueue.global().async { [weak self] in
                        if let data = try? Data(contentsOf: url!) {
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    self!.groupView.photoGroup.image = image
                                }
                            }
                        }
                    }
                }
            }
        } else {
            groupView.nameTextField.borderStyle = .roundedRect
            groupView.descriptionTextField.borderStyle = .roundedRect
            
            groupView.memberButton.isHidden = true
            groupView.photoGroup.image = UIImage(named: "groupPhoto")
            groupView.nameTextField.placeholder = "Название"
            groupView.descriptionTextField.placeholder = "Описание"
        }
        
        groupView.nameTextField.delegate = self
        groupView.descriptionTextField.delegate = self
        
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
