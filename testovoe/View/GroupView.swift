//
//  NewGroupView.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class GroupView: UIView {
    
    var nameTextField = UITextField()
    var quantityTextField = UITextField()
    var descriptionTextField = UITextField()
    
    var photoGroup = UIImageView()

    var nameLabel = UILabel()
    var quantityLabel = UILabel()
    var descriptionLabel = UILabel()
    
    var memberButton = UIButton()
    

    override init (frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupImage()
        
        setupTextField(textField: nameTextField, size: 50)
        //setupTextField(textField: quantityTextField, size: 80)
        setupTextField(textField: descriptionTextField, size: 80)

        setupLabel(label: nameLabel, text: "Название", size: 50)
        //setupLabel(label: quantityLabel, text: "Пользователей", size: 80)
        setupLabel(label: descriptionLabel, text: "Описание", size: 80)
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextField(textField: UITextField, size: Int) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.contentVerticalAlignment = .center
        addSubview(textField)
        
        textField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textField.topAnchor.constraint(equalTo: photoGroup.bottomAnchor, constant: CGFloat(size)).isActive = true
        textField.leftAnchor.constraint(equalTo: photoGroup.centerXAnchor, constant: 5).isActive = true
    }
    
    func setupLabel(label: UILabel, text: String, size: Int) {
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        addSubview(label)
        
        label.rightAnchor.constraint(equalTo: photoGroup.centerXAnchor, constant: -5).isActive = true
        label.topAnchor.constraint(equalTo: photoGroup.bottomAnchor, constant: CGFloat(size)).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupImage() {
        photoGroup.layer.cornerRadius = 80
        photoGroup.clipsToBounds = true
        photoGroup.translatesAutoresizingMaskIntoConstraints = false
        photoGroup.contentMode = .scaleAspectFill
    
        addSubview(photoGroup)
        
        if let superview = photoGroup.superview {
        
        photoGroup.topAnchor.constraint(equalTo: superview.topAnchor, constant: 120).isActive = true
        photoGroup.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: (UIScreen.main.bounds.width - 160) / 2).isActive = true
        photoGroup.heightAnchor.constraint(equalToConstant: 160).isActive = true
        photoGroup.widthAnchor.constraint(equalToConstant: 160).isActive = true
            
            memberButton.translatesAutoresizingMaskIntoConstraints = false
            memberButton.setTitle("Пользователи", for: .normal)
            memberButton.backgroundColor = .black
            memberButton.layer.cornerRadius = 5
            addSubview(memberButton)
            
            memberButton.topAnchor.constraint(equalTo: photoGroup.bottomAnchor, constant: 150).isActive = true
            memberButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
            memberButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            memberButton.centerXAnchor.constraint(equalTo: photoGroup.centerXAnchor).isActive = true
        }
    }
}
