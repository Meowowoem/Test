//
//  LoginView.swift
//  testovoe
//
//  Created by Anastasia on 21.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    var loginTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var registerButton: UIButton!
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTextField()
        setupButtons()
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField() {

        loginTextField = UITextField()
        loginTextField.placeholder = "Login"
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.textAlignment = .center
        loginTextField.borderStyle = .roundedRect
        addSubview(loginTextField)

        passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textAlignment = .center
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        addSubview(passwordTextField)

        if let superview = loginTextField.superview {
            loginTextField.topAnchor.constraint(equalTo: superview.topAnchor, constant: 200).isActive = true
            loginTextField.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            loginTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
            loginTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true

            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 5).isActive = true
            passwordTextField.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            passwordTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
            }
    }

    func setupButtons() {
        
        loginButton = UIButton()
        loginButton.backgroundColor = .black
        loginButton.setTitle("Login", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 5
        loginButton.isEnabled = false
        loginButton.layer.opacity = 0.2
        addSubview(loginButton)
        
        registerButton = UIButton()
        registerButton.backgroundColor = .black
        registerButton.setTitle("Registration", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.layer.cornerRadius = 5
//        registerButton.isEnabled = false
//        registerButton.layer.opacity = 0.2
        addSubview(registerButton)
        

        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: loginTextField.centerXAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    
}
