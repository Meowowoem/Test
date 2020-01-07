//
//  LoginView.swift
//  testovoe
//
//  Created by Anastasia on 21.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    var loginTextField = UITextField()
    var passwordTextField = UITextField()
    
    var firstNameTextField = UITextField()
    var lastNameTextField = UITextField()
    var emailTextField = UITextField()
    
    var containerTextField: UIStackView!
    
    
    var loginButton: UIButton!
    var registerButton: UIButton!
    var loginInfoLabel: UILabel!
    var loginSegmentedControl: UISegmentedControl!
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupContainer()
        setupTextField(textField: loginTextField, placeholder: "Логин", tag: 0)
        setupTextField(textField: passwordTextField, placeholder: "Пароль", tag: 1)
        setupTextField(textField: firstNameTextField, placeholder: "Имя", tag: 2)
        setupTextField(textField: lastNameTextField, placeholder: "Фамилия", tag: 3)
        setupTextField(textField: emailTextField, placeholder: "Email", tag: 4)
        
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        emailTextField.isHidden = true
        
        setupButtons()
        setupSegment()
        
        loginInfoLabel = UILabel()
        loginInfoLabel.font = UIFont.systemFont(ofSize: 16)
        loginInfoLabel.textColor = .red
        loginInfoLabel.alpha = 0
        loginInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loginInfoLabel)
        
        loginInfoLabel.bottomAnchor.constraint(equalTo: containerTextField.topAnchor, constant: -10).isActive = true
        loginInfoLabel.centerXAnchor.constraint(equalTo: containerTextField.centerXAnchor, constant: 0).isActive = true
        
        
    
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContainer() {
        containerTextField = UIStackView()
        containerTextField.translatesAutoresizingMaskIntoConstraints = false
        containerTextField.alignment = .center
        containerTextField.distribution = .fillEqually
        containerTextField.axis = .vertical
        containerTextField.spacing = 10
        addSubview(containerTextField)
        
        containerTextField.leftAnchor.constraint(equalTo: containerTextField.superview!.leftAnchor, constant: 0).isActive = true
        containerTextField.rightAnchor.constraint(equalTo: containerTextField.superview!.rightAnchor, constant: 0).isActive = true
        containerTextField.centerYAnchor.constraint(equalTo: containerTextField.superview!.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupTextField(textField: UITextField, placeholder: String, tag: Int) {
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.tag = tag
        containerTextField.addArrangedSubview(textField)
        
        
        textField.centerXAnchor.constraint(equalTo: containerTextField.centerXAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: containerTextField.widthAnchor, multiplier: 0.8).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupSegment() {
        loginSegmentedControl = UISegmentedControl(items: ["Авторизация", "Регистрация"])
        loginSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loginSegmentedControl)
        
        loginSegmentedControl.bottomAnchor.constraint(equalTo: containerTextField.topAnchor, constant: -20).isActive = true
        loginSegmentedControl.leftAnchor.constraint(equalTo: containerTextField.leftAnchor, constant: 50).isActive = true
        loginSegmentedControl.rightAnchor.constraint(equalTo: containerTextField.rightAnchor, constant: -50).isActive = true
        
    }
    
    


    func setupButtons() {
        
        loginButton = UIButton()
        loginButton.backgroundColor = .black
        loginButton.setTitle("Войти", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.layer.cornerRadius = 5
        loginButton.isEnabled = false
        loginButton.layer.opacity = 0.2
        addSubview(loginButton)
        
        registerButton = UIButton()
        registerButton.backgroundColor = .black
        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.layer.cornerRadius = 5
        registerButton.isHidden = true
        registerButton.isEnabled = false
        registerButton.layer.opacity = 0.2
        addSubview(registerButton)
        

        loginButton.topAnchor.constraint(equalTo: containerTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: containerTextField.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        registerButton.topAnchor.constraint(equalTo: containerTextField.bottomAnchor, constant: 20).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: containerTextField.centerXAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    
}
