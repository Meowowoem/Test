//
//  GroupTableViewCell.swift
//  testovoe
//
//  Created by Anastasia on 23.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var imageGroup = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupImageView()
        setupNameLabel()
        setupDescriptionLabel()
        
        
    }

    func setupImageView() {
        imageGroup.translatesAutoresizingMaskIntoConstraints = false
        imageGroup.layer.cornerRadius = 30
        imageGroup.clipsToBounds = true
        imageGroup.contentMode = .scaleAspectFill
        addSubview(imageGroup)
        
        imageGroup.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        imageGroup.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
       
        imageGroup.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageGroup.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 22)
        addSubview(nameLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: imageGroup.rightAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
        addSubview(descriptionLabel)
        
        descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
