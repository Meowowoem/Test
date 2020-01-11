//
//  ProfileViewController.swift
//  testovoe
//
//  Created by Anastasia on 21.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var profileView: ProfileView!
    
    var picker: UIDatePicker!
    
    var dateBD = Date()
    
    var user: Person!
    
    var ref: DatabaseReference!
    
    let auth = Auth.auth()
    
    var usersArray = Array<Person>()
    
    var textFieldIsEditing = false
    
    var currentLogin = ""
    
    var gradientLayer: CAGradientLayer!
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let currentUser = auth.currentUser else {
            navigationController?.pushViewController(LoginViewController(), animated: true)
            return
        }
        
        user = Person(user: currentUser)
        
        ref = Database.database().reference(withPath: "users").child(user.uid!)
        
        profileView = ProfileView(frame: view.bounds)
        
        self.view.addSubview(profileView)
        
        view.backgroundColor = .white
        
        title = "Профиль"
        
        print(currentLogin)
        
        showProfile()
        setupGradient()
        
        buttons()
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -150
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
        
        
        profileView.firstNameTextField.delegate = self
        profileView.lastNameTextField.delegate = self
        profileView.dateOfBirthTextField.delegate = self
        
        
    }
    
    func buttons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Выйти", style: .done, target: self, action: #selector(exit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
        
        profileView.buttonGroup.addTarget(self, action: #selector(goToGroups), for: .touchUpInside)
        
        let tapGesturePhoto = UITapGestureRecognizer(target: self, action: #selector(pickPhoto(_:)))
        profileView.photoImage.addGestureRecognizer(tapGesturePhoto)
        profileView.photoImage.addSubview(profileView.editImageButton)
        
        
        let tapKey: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapKey)
        
        profileView.firstNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        profileView.lastNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        profileView.buttonDate.addTarget(self, action: #selector(chooseDate), for: .touchUpInside)
    }
    
    func setupGradient() {
        gradientLayer = CAGradientLayer()
                profileView.layer.insertSublayer(gradientLayer, at: 0)
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [UIColor(red: 1, green: 0, blue: 0.22, alpha: 0.1).cgColor, UIColor(red: 0.38, green: 0.22, blue: 0.48, alpha: 1).cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 0.55, green: 0.20, blue: 0.55, alpha: 1)
        
        tabBarController?.tabBar.unselectedItemTintColor = .white
    }
    
    //MARK: - Go to groups
    @objc func goToGroups() {
        navigationController?.pushViewController(GroupViewController(), animated: true)
    }
    
    
    
    //MARK: - Allows editing
    @objc func editProfile() {
        textFieldIsEditing = true
        profileView.loginTextField.isEnabled = false
        profileView.dateOfBirthTextField.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        profileView.photoImage.isUserInteractionEnabled = true
        profileView.photoImage.layer.borderWidth = 4
        profileView.firstNameTextField.borderStyle = .roundedRect
        profileView.lastNameTextField.borderStyle = .roundedRect
        profileView.buttonDate.isHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProfile))
    }
    
    //MARK: - Logout
    @objc func exit() {
        let alert = UIAlertController(title: "Вы действительно хотите выйти?", message: nil , preferredStyle: .alert)
        let exit = UIAlertAction(title: "Да", style: .default) { (action) in
            do {
                try self.auth.signOut()
            } catch {
                print(error.localizedDescription)
            }
            self.navigationController?.popViewController(animated: true)
            
        }
        let close = UIAlertAction(title: "Нет", style: .cancel)
        alert.addAction(exit)
        alert.addAction(close)
        present(alert, animated: true)
        

    }
    
    //MARK: - Show profile
    func showProfile() {
        
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self!.profileView.firstNameTextField.text = dictionary["firstName"] as? String
                self!.profileView.lastNameTextField.text = dictionary["lastName"] as? String
                self!.profileView.loginTextField.text = dictionary["nickname"] as? String
                self!.profileView.dateOfBirthTextField.text = dictionary["dateOfBirth"] as? String
                guard let urlString = dictionary["userImage"] as? String else {
                    self?.profileView.photoImage.image = UIImage(named: "personPhoto")
                    return
                }
                let url = URL(string: urlString)
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self!.profileView.photoImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Save changes
    @objc func saveProfile() {
        dismissKeyboard()
        let imageName = user.uid
        let storageRef = Storage.storage().reference().child("\(imageName!).png")
        
        if let uploadData = self.profileView.photoImage.image?.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                storageRef.downloadURL { [weak self] (url, error) in
                    if let downloadUrl = url {
                        
                        let directoryURL : NSURL = downloadUrl as NSURL
                        let urlString:String = directoryURL.absoluteString!
                        
                        let person = Person(firstName: self!.profileView.firstNameTextField.text!,
                                            lastName: self!.profileView.lastNameTextField.text!,
                                            nickname: self!.profileView.loginTextField.text!,
                                            dateOfBirth: self!.profileView.dateOfBirthTextField.text!)
                        self!.ref.setValue(["firstName": person.firstName!, "lastName": person.lastName!, "nickname": person.nickname!, "dateOfBirth": person.dateOfBirth!, "userImage": urlString, "email": self!.user.email])
                    }
                }
            }
        }
        textFieldIsEditing = false
        profileView.photoImage.isUserInteractionEnabled = false
        profileView.photoImage.layer.borderWidth = 2
        profileView.firstNameTextField.borderStyle = .none
        profileView.lastNameTextField.borderStyle = .none
        profileView.buttonDate.isHidden = true
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfile))
    }
    
    //MARK: - Choose date
    @objc func chooseDate() {
        print("123")
        dismissKeyboard()
        
        picker = UIDatePicker()
        picker.datePickerMode = .date
        
        
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.addSubview(picker)
        //picker.addTarget(self, action: #selector(chooseDateOfBirth), for: .valueChanged)
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

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textFieldIsEditing == true {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Hide keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func textFieldChanged() {
        if profileView.firstNameTextField.text?.isEmpty == false && profileView.lastNameTextField.text?.isEmpty == false {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            textField.resignFirstResponder()
        return true
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
