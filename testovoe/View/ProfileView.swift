//
//  ProfileView.swift
//  testovoe
//
//  Created by Anastasia on 22.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    var loginTextField = UITextField()
    var firstNameTextField = UITextField()
    var lastNameTextField = UITextField()
    var dateOfBirthTextField = UITextField()
    var buttonGroup = UIButton()
    
    var photoImage = UIImageView()
    
    var loginLabel = UILabel()
    var firstNameLabel = UILabel()
    var lastNameLabel = UILabel()
    var dateOfBirthLabel = UILabel()
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupImage()
        
        setupTextField(textField: loginTextField, size: 50)
        setupTextField(textField: firstNameTextField, size: 80)
        setupTextField(textField: lastNameTextField, size: 110)
        setupTextField(textField: dateOfBirthTextField, size: 140)
        
        setupLabel(label: loginLabel, text: "Никнейм", size: 50)
        setupLabel(label: firstNameLabel, text: "Имя", size: 80)
        setupLabel(label: lastNameLabel, text: "Фамилия", size: 110)
        setupLabel(label: dateOfBirthLabel, text: "День рождения", size: 140)
        
        setupButton()
        
        
        
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField(textField: UITextField, size: Int) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.contentVerticalAlignment = .center
        addSubview(textField)
        
        textField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textField.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: CGFloat(size)).isActive = true
        textField.leftAnchor.constraint(equalTo: photoImage.centerXAnchor, constant: 5).isActive = true
        
    }
    
    func setupLabel(label: UILabel, text: String, size: Int) {
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        addSubview(label)
        
        label.rightAnchor.constraint(equalTo: photoImage.centerXAnchor, constant: -5).isActive = true
        label.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: CGFloat(size)).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupImage() {
        photoImage.layer.cornerRadius = 80
        photoImage.clipsToBounds = true
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.contentMode = .scaleAspectFill
        
        addSubview(photoImage)
        
        if let superview = photoImage.superview {
            
            photoImage.topAnchor.constraint(equalTo: superview.topAnchor, constant: 100).isActive = true
            photoImage.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: (UIScreen.main.bounds.width - 160) / 2).isActive = true
            photoImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
            photoImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
            
        }
        
    }
    
    func setupButton() {
        buttonGroup.translatesAutoresizingMaskIntoConstraints = false
        buttonGroup.setTitle("Группы", for: .normal)
        buttonGroup.backgroundColor = .black
        buttonGroup.layer.cornerRadius = 5
        addSubview(buttonGroup)
        
        
        
        buttonGroup.topAnchor.constraint(equalTo: photoImage.bottomAnchor, constant: 200).isActive = true
        buttonGroup.centerXAnchor.constraint(equalTo: photoImage.centerXAnchor).isActive = true
        buttonGroup.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonGroup.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}