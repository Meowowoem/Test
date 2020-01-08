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
    
    var gradientLayer: CAGradientLayer!
    
    let ref = Database.database().reference(withPath: "users")
    
    var tabBarItemONE: UITabBarItem = UITabBarItem()
    var tabBarItemTWO: UITabBarItem = UITabBarItem()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginView.loginTextField.text = ""
        loginView.passwordTextField.text = ""
        tabBarController?.tabBar.isHidden = true
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        navigationItem.title = "Авторизация"
        loginView = LoginView(frame: view.bounds)
        self.view.addSubview(loginView)
        
        setupGradient()
        
        checkAuth()
        loginView.loginSegmentedControl.selectedSegmentIndex = 0
        loginView.loginSegmentedControl.addTarget(self, action: #selector(changeLoginRegister), for: .valueChanged)
        
        loginView.loginButton.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        
        setupTextFields()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
            

        
    }
    
    func setupTextFields() {
        //delegate
        loginView.loginTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.firstNameTextField.delegate = self
        loginView.lastNameTextField.delegate = self
        loginView.emailTextField.delegate = self
        
        //settings for fields
        loginView.passwordTextField.isSecureTextEntry = true
        loginView.emailTextField.keyboardType = .emailAddress
        
        loginView.loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginView.passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginView.firstNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginView.lastNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginView.emailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -100
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
    }
    
    func setupGradient() {
        gradientLayer = CAGradientLayer()
                loginView.layer.insertSublayer(gradientLayer, at: 0)
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [UIColor(red: 1, green: 0, blue: 0.22, alpha: 0.1).cgColor, UIColor(red: 0.38, green: 0.22, blue: 0.48, alpha: 1).cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    @objc func changeLoginRegister(target: UISegmentedControl) {
        if target.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self!.loginView.firstNameTextField.alpha = 0
                self!.loginView.lastNameTextField.alpha = 0
                self!.loginView.emailTextField.alpha = 0
                self!.loginView.firstNameTextField.isHidden = true
                self!.loginView.lastNameTextField.isHidden = true
                self!.loginView.emailTextField.isHidden = true
                self!.loginView.registerButton.isHidden = true
                self!.loginView.loginButton.isHidden = false
            })
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self!.loginView.firstNameTextField.alpha = 1
                self!.loginView.lastNameTextField.alpha = 1
                self!.loginView.emailTextField.alpha = 1
                self!.loginView.firstNameTextField.isHidden = false
                self!.loginView.lastNameTextField.isHidden = false
                self!.loginView.registerButton.isHidden = false
                self!.loginView.emailTextField.isHidden = false
                self!.loginView.loginButton.isHidden = true
            })
            
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func checkAuth() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                let profileVC = ProfileViewController()
//                profileVC.currentLogin = (self?.loginView.loginTextField.text)!
                self?.navigationController?.pushViewController(profileVC, animated: true)
            }
            //MARK: - Allow tabbar
//                else {
//                let tabBarControllerItems = self?.tabBarController?.tabBar.items
//
//                if let arrayOfTabBarItems = tabBarControllerItems as AnyObject as? NSArray{
//
//
//                    self?.tabBarItemTWO = arrayOfTabBarItems[1] as! UITabBarItem
//                    self?.tabBarItemTWO.isEnabled = false
//
//                }
//            }
        }
    }
    
    
    //MARK: - Log in and sing up Firebase
    @objc func logIn() {
        guard let inputLogin = loginView.loginTextField.text, let inputPass = loginView.passwordTextField.text, inputLogin != "", inputPass != "" else {
            displayInfo(text: "Данные неправильные!")
            return
            
        }
        
        //MARK: - Search email by login
        let group = DispatchGroup()
        group.enter()
        var email = ""
        self.ref.observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            for item in value! {
                if let name = item.value as? [String: String] {
                    if name["nickname"]?.lowercased() == inputLogin.lowercased() {
                        email = name["email"]!
                        break
                    }
                }
            }
            group.leave()
        }
        //MARK: - Login and error handler
        group.notify(queue: DispatchQueue.main) {
            Auth.auth().signIn(withEmail: email, password: inputPass) { [weak self] (user, error) in
                
                switch error {
                case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                    self?.displayInfo(text: "Неправильный пароль!")
                case .some:
                    self?.displayInfo(text: "Такого пользователя нет! Зарегистрируйтесь.")
                case .none:
                    break
                }
            }
        }
        
        
        
    }
    
    //MARK: - Register
    @objc func addUser() {
        let inputLogin = loginView.loginTextField.text
        var loginExists: Bool!
        let group = DispatchGroup()
        group.enter()
        
        self.ref.observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            for item in value! {
                if let name = item.value as? [String: String] {
                    if name["nickname"]?.lowercased() == inputLogin?.lowercased() {
                        loginExists = true
                        break
                    } else {
                        loginExists = false
                    }
                }
            }
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            if loginExists == false {
                Auth.auth().createUser(withEmail: self.loginView.emailTextField.text!, password: self.loginView.passwordTextField.text!) { [weak self] (user, error) in
                    if error == nil {
                        if user != nil {
                            print("Добавили пользователя!")
                            guard let currentUser = Auth.auth().currentUser else { return }
                            let user = Person(user: currentUser)
                            
                            let ref = Database.database().reference(withPath: "users").child(user.uid!)
                            ref.setValue(["firstName": self?.loginView.firstNameTextField.text?.capitalized ?? "",
                                          "lastName": self?.loginView.lastNameTextField.text?.capitalized ?? "",
                                          "nickname": self?.loginView.loginTextField.text?.capitalized ?? "",
                                          "dateOfBirth": "не указано",
                                          "userImage": nil,
                                          "email": user.email!])
                        }
                    } else {
                        switch error {
                        case .some(let error as NSError) where error.code == AuthErrorCode.weakPassword.rawValue:
                            self?.displayInfo(text: "Пароль должен содержать от 6 символов!")
                        case .some(let error as NSError) where error.code == AuthErrorCode.invalidEmail.rawValue:
                            self?.displayInfo(text: "Указан неправильный Email!")
                        case .some(let error as NSError) where error.code == AuthErrorCode.emailAlreadyInUse.rawValue:
                            self?.displayInfo(text: "Этот Email уже занят!")
                        case .some:
                            self?.displayInfo(text: "Попробуйте еще раз!")
                        case .none:
                            break
                        }
                    }
                }
            } else {
                self.displayInfo(text: "Указанный логин занят!")
            }
        }
    }
    
    //MARK: - Message error
    func displayInfo(text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text , preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Control text in text field
    @objc func textFieldChanged() {
        if loginView.loginSegmentedControl.selectedSegmentIndex == 0 {
            if loginView.loginTextField.text?.isEmpty == false && loginView.passwordTextField.text?.isEmpty == false {
                loginView.loginButton.isEnabled = true
                loginView.loginButton.layer.opacity = 1
            } else {
                loginView.loginButton.isEnabled = false
                loginView.loginButton.layer.opacity = 0.2
            }
        } else {
            if loginView.loginTextField.text?.isEmpty == false && loginView.passwordTextField.text?.isEmpty == false && loginView.firstNameTextField.text?.isEmpty == false && loginView.lastNameTextField.text?.isEmpty == false && loginView.emailTextField.text?.isEmpty == false {
                loginView.registerButton.isEnabled = true
                loginView.registerButton.layer.opacity = 1
            } else {
                loginView.registerButton.isEnabled = false
                loginView.registerButton.layer.opacity = 0.2
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if loginView.loginSegmentedControl.selectedSegmentIndex == 0 {
            if textField.tag == 0 {
                textField.superview?.viewWithTag(1)?.becomeFirstResponder()
            } else if textField.tag == 1 {
                textField.resignFirstResponder()
            }
        } else {
            let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
}
