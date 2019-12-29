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
    
    var tabBarItemONE: UITabBarItem = UITabBarItem()
    var tabBarItemTWO: UITabBarItem = UITabBarItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginView.loginTextField.text = ""
        loginView.passwordTextField.text = ""
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarItemTWO.isEnabled = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = "Авторизация"
        loginView = LoginView(frame: view.bounds)
        self.view.addSubview(loginView)
        
        
        
        checkAuth()
        
        
        
        
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
    
    func checkAuth() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                let profileVC = ProfileViewController()
                self?.navigationController?.pushViewController(profileVC, animated: true)
            } else {
                let tabBarControllerItems = self?.tabBarController?.tabBar.items
                
                if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{
                    
                    
                    self?.tabBarItemTWO = arrayOfTabBarItems[1] as! UITabBarItem
                    self?.tabBarItemTWO.isEnabled = false
                    
                }
            }
        }
    }
    
    
    //MARK: - Log in and sing up Firebase
    @objc func logIn() {
        guard let inputEmail = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text, inputEmail != "", inputPass != "" else {
            displayInfo(text: "Данные неправильные!")
            return
            
        }
        
        Auth.auth().signIn(withEmail: inputEmail, password: inputPass) { [weak self] (user, error) in
            
            switch error {
            case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                self?.displayInfo(text: "Неправильный пароль!")
            case .some:
                self?.displayInfo(text: "Такого пользователя нет!")
            case .none:
                self?.displayInfo(text: "Входим!")
            }
        }
    }
    
    //MARK: - Register
    @objc func addUser() {
        guard let inputEmail = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: inputEmail, password: inputPass) { [weak self] (user, error) in
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
                self?.displayInfo(text: "Этот email занят!")
            }
        }
        
    }
    
    func displayInfo(text: String) {
        loginView.loginInfoLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.loginView.loginInfoLabel.alpha = 1
        }) { [weak self] complete in
            self?.loginView.loginInfoLabel.alpha = 0
        }
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
