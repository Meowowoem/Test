//
//  User.swift
//  testovoe
//
//  Created by Anastasia on 22.12.2019.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import RealmSwift

class User: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    @objc dynamic var firstName: String?
    @objc dynamic var lastName: String?
    @objc dynamic var dateOfBirth: Date?
    @objc dynamic var photo: Data?
    
    convenience init (login: String, password: String, firstName: String?, lastName: String?, dateOfBirth: Date?, photo: Data?) {
        self.init()
        self.login = login
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.photo = photo
    }
    
//    let users = ["Meow"]
//    
//    func saveUsers() {
//        for user in users {
//            
//            let photo = UIImage(named: user)
//            guard let photoData = photo?.pngData() else { return }
//            
//            let newUser = User()
//            
//            newUser.login = user
//            newUser.password = "12345"
//            newUser.firstName = "Никита"
//            newUser.lastName = "Сальников"
//            newUser.dateOfBirth = Date()
//            newUser.photo = photoData
//        }
//    }
    
}
