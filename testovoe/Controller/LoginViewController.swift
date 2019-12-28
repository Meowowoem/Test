//
//  ViewController.swift
//  testovoe
//
//  Created by Anastasia on 20.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var loginView: LoginView!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginView.loginTextField.text = ""
        loginView.passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Авторизация"
        loginView = LoginView(frame: view.bounds)
        self.view.addSubview(loginView)
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                let profileVC = ProfileViewController()
                self?.navigationController?.pushViewController(profileVC, animated: true)
            }
        }

        
        
        
        loginView.loginButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)

        loginView.loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    //MARK: - Log in and sing up Firebase
        @objc func logIn() {
            guard let inputEmail = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text else { return }
    
            Auth.auth().signIn(withEmail: inputEmail, password: inputPass) { (user, error) in
                if error != nil {
                    //отобразить лейбл об ошибке
                    //self.
                    return
                }
                if user != nil {
                    print("Данные верные!")

                    return
                } else {
                    //отобразить лейбл об отсутствии пользователя
                    //self.
                }
            }
        }
    
    //MARK: - Register
    @objc func addUser() {
        guard let inputEmail = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text else { return }
        print("Добавили пользователя!")
        Auth.auth().createUser(withEmail: inputEmail, password: inputPass) { (user, error) in
            if error == nil {
                if user != nil {
                    print("Добавили пользователя!")
                    guard let currentUser = Auth.auth().currentUser else { return }
                    let user = Person(user: currentUser)

                    
                    let ref = Database.database().reference(withPath: "users").child(user.uid!)
                    ref.setValue(["firstName": "не указано", "lastName": "не указано", "nickname": "не указано", "dateOfBirth": "не указано", "userImage": nil, "email": user.email])
                } else {
                    print("пользователя нет")
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
        loginView.registerButton.isEnabled = false
        loginView.registerButton.layer.opacity = 0.2
    }


    //MARK: - Control text in login text field
    @objc func textFieldChanged() {
        if loginView.loginTextField.text?.isEmpty == false && loginView.passwordTextField.text?.isEmpty == false {
            loginView.loginButton.isEnabled = true
            loginView.loginButton.layer.opacity = 1
        } else {
            loginView.loginButton.isEnabled = false
            loginView.loginButton.layer.opacity = 0.2
        }
    }
    
}


