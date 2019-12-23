//
//  ViewController.swift
//  testovoe
//
//  Created by Anastasia on 20.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    var loginView: LoginView!
    var users: Results<User>!
    
    let defaults = UserDefaults.standard
    let currentUser = UserDefaults.standard.string(forKey: "currentUser")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLogin()
        
        users = realm.objects(User.self)
        
        tabBarController?.tabBar.isHidden = true
        
        
        title = "Авторизация"
        loginView = LoginView(frame: view.bounds)
        self.view.addSubview(loginView)

        
        
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
    
    func checkLogin() {
        if currentUser != nil {
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: false)
        }
    }
    
    //MARK: - Log in and sing up
    @objc func logIn() {
        guard let inputLogin = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text else { return }
        
        let user = StorageManager.getDataUsers(inputLogin)

        if inputLogin == user.login && inputPass == user.password {
            print("Данные верные!")
            
            defaults.set(user.login, forKey: "currentUser")
            
            
            let profileVC = ProfileViewController()

            navigationController?.pushViewController(profileVC, animated: true)
        } else {
            print("Такого пользователя не существует!")
            loginView.loginButton.isEnabled = false
            loginView.loginButton.layer.opacity = 0.2
            loginView.registerButton.isEnabled = true
            loginView.registerButton.layer.opacity = 1

        }
    }
    //MARK: - Register
    @objc func addUser() {
        guard let inputLogin = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text else { return }
        print("Добавили пользователя!")
        addNewUser(inputLogin, inputPass)
        loginView.registerButton.isEnabled = false
        loginView.registerButton.layer.opacity = 0.2
    }

    //MARK: - Add new user
    private func addNewUser(_ login: String, _ password: String) {

        let newUser = User(login: login, password: password, firstName: nil, lastName: nil, dateOfBirth: nil, photo: nil)

        StorageManager.saveObject(newUser)
        loginView.loginButton.isEnabled = true
        loginView.loginButton.layer.opacity = 1

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


